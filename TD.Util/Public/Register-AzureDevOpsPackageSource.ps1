<#
.SYNOPSIS
Registers a package source from AzureDevOps Feed / Artifacts

.DESCRIPTION
Registers a package source from AzureDevOps Feed /Artifacts. If already found removes reference first.

.PARAMETER Name
Name of package source

.PARAMETER Url
Url of package feed

.PARAMETER Credential
Credentials to access feed

.Example
Register-AzureDevOpsPackageSource -Name myFeed -Url https://pkgs.dev.azure.com/myCompany/_packaging/myFeed/nuget/v2
#>
function Register-AzureDevOpsPackageSource($Name, $Url, [System.Management.Automation.PSCredential]$Credential)
{
    if ($Credential)
    {
        try 
        {
            Invoke-WebRequest -Uri $Url -Credential $Credential | Out-Null # check for access to artifacts with credential
        }
        catch {
            Throw "Register-AzureDevOpsPackageSource error for $Url : $($_.Exception.Message)"
        }
    }

    if (Get-PSRepository -Name $Name -ErrorAction Ignore) { Unregister-PSRepository -Name $Name }
    Register-PSRepository -Name $Name -SourceLocation $Url -InstallationPolicy Trusted -Credential $Credential
}