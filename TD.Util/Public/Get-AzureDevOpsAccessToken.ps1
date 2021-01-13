<#
.SYNOPSIS
Get the Azure DevOps Personal Access Token from Azure Devops Hosted Agent (In build/deploy) or the Windows Credential Store

.DESCRIPTION
Get the Azure DevOps Personal Access Token from Azure Devops Hosted Agent (In build/deploy) or the Windows Credential Store. This function is MS Windows only when running local.

.PARAMETER Url
Url of the Azure DevOps subscription like  https://(mycompany)@dev.azure.com/(mycompany)

.Example
$token = Get-AzureDevOpsAccessToken 'https://mycompany@dev.azure.com/mycompany')
#>
function Get-AzureDevOpsAccessToken([Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Url)
{
    $token = $env:SYSTEM_ACCESSTOKEN
    if ([string]::IsNullOrEmpty($token))
    {
        if (-not(Get-Module CredentialManager -ListAvailable)) { Install-Module CredentialManager -Scope CurrentUser -Force }
        Import-Module CredentialManager
        $credential = Get-StoredCredential -Target "git:$Url"
        if ($null -eq $credential)
        {
            Throw "No Azure DevOps credentials found in credential store"
        }
        Write-Verbose "Using Azure DevOps Access Token from Windows Credential Store"
        $token = $credential.GetNetworkCredential().Password
    }
    return $token
}