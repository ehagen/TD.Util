<#
.SYNOPSIS
Assert if logged-in to Azure with powershell Az modules

.DESCRIPTION
Assert if logged-in to Azure with powershell Az modules

.Example
Assert-AzureConnected
#>
function Assert-AzureConnected
{
    Initialize-Azure

    $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    if (-not $azProfile.Accounts.Count)
    {
        Throw "Powershell Az error: Ensure you are logged in."
    }
}