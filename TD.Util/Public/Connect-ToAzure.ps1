<#
.SYNOPSIS
Connect to Azure with Powershell Az modules

.DESCRIPTION
Connect to Azure with Powershell Az modules, use 'az cli' as fallback to connect

.Example
Connect-ToAzure
#>
function Connect-ToAzure()
{
    Write-Verbose "Connect-ToAzure"
    Write-Verbose "  SubscriptionId: $SubscriptionId"

    # check already logged-in to Azure
    if (!(Test-AzureConnected))
    {
        # try to find logged-in user via az cli if installed
        Write-Verbose 'Connect to azure with Azure Cli configuration'
        try
        {
            $token = $(az account get-access-token --query accessToken --output tsv)
            $id = $(az account show --query user.name --output tsv)
            if ($token -and $id)
            {
                Connect-AzAccount -AccessToken $token -AccountId $id -Scope Process
            }
        }                
        catch
        {
            # use default, already connected user in this session
        }
    }

    Assert-AzureConnected

    $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    Write-Verbose "Az Account: $($azProfile.DefaultContext.Account.Id)"
    Write-Verbose "Az Subscription: $($azProfile.DefaultContext.Subscription.Name) - $($azProfile.DefaultContext.Subscription.Id)"
}