<#
.SYNOPSIS
Test if logged-in to Azure with powershell Az modules

.DESCRIPTION
Test if logged-in to Azure with powershell Az modules

.Example
Test-AzureConnected
#>
function Test-AzureConnected
{
    Initialize-AzureModules

    try
    {  
        $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
        return !(-not $azProfile.Accounts.Count)
    }
    catch
    {
        return $false
    }
}