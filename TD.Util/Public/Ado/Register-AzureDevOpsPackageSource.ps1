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
function Register-AzureDevOpsPackageSource([Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Name, [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Url, [System.Management.Automation.PSCredential]$Credential)
{
    Write-Verbose "Register-AzureDevOpsPackageSource $Name"

    if ($Credential)
    {
        Write-Verbose "Performing Credential check..."
        try 
        {
            Invoke-RestMethod -Uri $Url -Credential $Credential | Out-Null # check for access to artifacts with credential
        }
        catch
        {
            Throw "Register-AzureDevOpsPackageSource error for $Url : $($_.Exception.Message)"
        }
    }
    
    try
    {
        if (Get-PSRepository -Name $Name -ErrorAction Ignore) { Unregister-PSRepository -Name $Name }
        Register-PSRepository -Name $Name -SourceLocation $Url -InstallationPolicy Trusted -Credential $Credential
    }
    catch
    {
        if ($env:windir)
        {
            if ($_.Exception.Message -eq "The property 'Name' cannot be found on this object. Verify that the property exists.")
            {                
                Write-Warning "Maybe invalid PSRepositories.xml detected in 'C:\Users\$($env:USERNAME)\AppData\Local\Microsoft\Windows\PowerShell\PowerShellGet', check file for correctness"
            }
        }
        Write-Host $_
        Throw
    }
}