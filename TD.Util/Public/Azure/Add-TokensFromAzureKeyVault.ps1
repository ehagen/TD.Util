<#
.SYNOPSIS
Get Azure Keyvault secrets and add them to token collection

.DESCRIPTION
Get secrets from Azure Keyvault and add them to token collection, use default logged-in account to Azure or try to get it from 'az cli'

.PARAMETER Vault
Name of the Azure KeyVault

.PARAMETER Tokens
Hashtable to add secrets to

.PARAMETER SubscriptionId
Azure Subscription ID

.Example
$Tokens = @{}
Add-TokensFromAzureKeyVault -Vault 'MyVaultName' -Tokens $Tokens -SubscriptionId 'mySubscriptionId'
#>
function Add-TokensFromAzureKeyVault([Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Vault, [Parameter(Mandatory = $true)]$Tokens, $SubscriptionId)
{
    Write-Verbose "Add-TokensFromAzureKeyVault"
    Write-Verbose "           Vault: $Vault"
    Write-Verbose "  SubscriptionId: $SubscriptionId"

    function Add-Secret($Name, $Value)
    {
        if (!$Tokens.ContainsKey($Name))
        {
            Write-Host "Adding secret $Name : ******* to Token Store"
            $Tokens.Add($Name, $Value)
        }
    }

    Connect-ToAzure

    if ($SubscriptionId)
    {
        Select-AzureDefaultSubscription -SubscriptionId $SubscriptionId
    }

    $warning = (Get-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings -ErrorAction Ignore) -eq 'true'
    Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"
    try
    {
        try
        {
            $secrets = Get-AzKeyVaultSecret -VaultName $Vault
            foreach ($secret in $secrets)
            {
                try
                {
                    $s = Get-AzKeyVaultSecret -VaultName $Vault -Name $secret.Name
                }
                Catch [Microsoft.Azure.KeyVault.Models.KeyVaultErrorException]
                {
                    # ignore disabled/expired secrets
                }
                #$pass = $s.SecretValue | ConvertFrom-SecureString -AsPlainText
                $cred = New-Object System.Management.Automation.PSCredential($secret.Name, $s.SecretValue)
                Add-Secret $secret.Name $cred
            }
        }   
        catch
        {
            # Generic KeyVaultErrorException
            if ($_.Exception.Message.Contains("Operation returned an invalid status code 'Forbidden'"))
            {
                Write-Warning "Check if your service principal '$(([Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile).DefaultContext.Account.Id)' has Secret and Certificate Permissions (List,Get) for this KeyVault '$Vault'. Check the Vaults Access Policies"
            }
            Throw
        }
    }
    finally
    {
        Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings $warning
    }
}