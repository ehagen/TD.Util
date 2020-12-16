<#
.SYNOPSIS
Get Azure Keyvault secrets and add them to token collection

.DESCRIPTION
Get secrets from Azure Keyvault and add them to token collection

.PARAMETER Vault
Name of the Azure KeyVault

.PARAMETER Tokens
Hashtable to add secrets to

.PARAMETER SubscriptionId
Azure Subscription ID

.PARAMETER ServicePrincipal
Azure ServicePrincipal ID

.Example
$Tokens = @{}
Add-TokensFromAzureKeyVault -Vault 'MyVaultName' -Tokens $Tokens -SubscriptionId 'mySubscriptionId'
#>
function Add-TokensFromAzureKeyVault($Vault, $Tokens, $SubscriptionId, $ServicePrincipal)
{
    function Add-Secret($Name, $Value)
    {
        if (!$Tokens.ContainsKey($Name))
        {
            Write-Host "Adding secret $Name : *******"
            $Tokens.Add($Name, $Value)
        }
    }

    if ($null -eq (Get-Module -ListAvailable 'Az'))
    {
        Install-Module -Name Az -AllowClobber -Scope CurrentUser -Repository PSGallery
        Install-Module -Name Az.Accounts -AllowClobber -Scope CurrentUser -Repository PSGallery
    }
    else
    {
        Import-Module Az -Scope local -Force
        Import-Module Az.Accounts -Scope local -Force
    }

    if (!!$env:SYSTEM_TEAMPROJECT)
    {
        $token = $(az account get-access-token --query accessToken --output tsv)
        $id = $(az account show --query user.name --output tsv)
        Connect-AzAccount -AccessToken $token -AccountId $id -Scope Process
    }
    else
    {
        if ($ServicePrincipal )
        {
            Connect-AzAccount -ServicePrincipal $ServicePrincipal
        }

        if ($SubscriptionId)
        {
            $ctxList = Get-AzContext -ListAvailable
            foreach ($ctx in $ctxList)
            {
                if ($ctx.Subscription.Id -eq $SubscriptionId)
                {
                    Select-AzContext -Name $ctx.Name
                    break
                }
            }
        }
    }

    $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    if (-not $azProfile.Accounts.Count)
    {
        Throw "Powershell Az error: Ensure you are logged in."
    }

    $warning = (Get-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings -ErrorAction Ignore) -eq 'true'
    Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"    
    try 
    {
        $secrets = Get-AzKeyVaultSecret -VaultName $Vault
        foreach ($secret in $secrets)
        {
            $s = Get-AzKeyVaultSecret -VaultName $Vault -Name $secret.Name
            #$pass = $s.SecretValue | ConvertFrom-SecureString -AsPlainText
            $cred = New-Object System.Management.Automation.PSCredential($secret.Name, $s.SecretValue)
            Add-Secret $secret.Name $cred
        }       
    }
    finally 
    {
        Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings $warning
    }
}