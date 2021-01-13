<#
.SYNOPSIS
Get the Azure DevOps Credentials from Azure Devops Hosted Agent (In build/deploy) or the Windows Credential Store

.DESCRIPTION
Get the Azure DevOps Credentials from Azure Devops Hosted Agent (In build/deploy) or the Windows Credential Store. This function is MS Windows only when running local.

.PARAMETER Url
Url of the Azure DevOps subscription like  https://(mycompany)@dev.azure.com/(mycompany)

.Example
$cred = Get-AzureDevOpsCredential 'https://mycompany@dev.azure.com/mycompany')
#>
function Get-AzureDevOpsCredential([Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Url)
{
    $token = $env:SYSTEM_ACCESSTOKEN
    if ([string]::IsNullOrEmpty($token)) 
    {
        if (-not(Get-Module CredentialManager -ListAvailable)) { Install-Module CredentialManager -Scope CurrentUser -Force }
        Import-Module CredentialManager
        $credential = Get-StoredCredential -Target "git:$Url"
        if ($null -eq $credential)
        {
            Throw "No Azure DevOps credentials found. It should be passed in via env:SYSTEM_ACCESSTOKEN."
        }
        Write-Verbose "Using Azure DevOps Access Token from Windows Credential Store"
    }
    else
    {
        Write-Verbose "Using Azure DevOps Access Token from Hosted Agent"
        $secureToken = $token | ConvertTo-SecureString -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential(".", $secureToken)
    }
    return $credential
}