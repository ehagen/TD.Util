<#
.SYNOPSIS
Import PowerShell module(s) and if not found install them from Azure DevOps Artifacts

.DESCRIPTION
Import PowerShell module(s) and if not found install them from Azure DevOps Artifacts

.PARAMETER PackageSource
Azure DevOps packagesource name

.PARAMETER Modules
Array of modules to import

.PARAMETER Credential
Credentials to access feed

.PARAMETER Latest
Always import latest modules

.EXAMPLE
Register-AzureDevOpsPackageSource -Name myFeed -Url https://pkgs.dev.azure.com/myCompany/_packaging/myFeed/nuget/v2
Import-AzureDevOpsModules -PackageSource 'myFeed' -Modules @('myModule') -Latest
#>
function Import-AzureDevOpsModules($PackageSource, $Modules, [System.Management.Automation.PSCredential]$Credential, [Switch]$Latest)
{
    foreach ($module in $Modules)
    {
        if (-not (Get-Module -ListAvailable -Name $module) -or $Latest.IsPresent)
        {
            Install-Module $module -Repository $PackageSource -Scope CurrentUser -Force -AllowClobber -Credential $Credential
        }
        else
        {
            Import-Module $module
        }
    }
}