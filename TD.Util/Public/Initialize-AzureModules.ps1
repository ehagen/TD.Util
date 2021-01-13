<#
.SYNOPSIS
Initializes (install or import) the Azure Az modules into current Powershell session

.DESCRIPTION
Initializes (install or import) the Azure Az modules into current Powershell session

.Example
Initialize-AzureModules
#>
function Initialize-AzureModules
{
    if ($Global:AzureInitialized) { return }

    if ($null -eq (Get-Module -ListAvailable 'Az'))
    {
        Install-Module -Name Az -AllowClobber -Scope CurrentUser -Repository PSGallery -Force
        Install-Module -Name Az.Accounts -AllowClobber -Scope CurrentUser -Repository PSGallery -Force
    }
    else
    {
        if (!(Get-Module -Name Az))
        {
            Import-Module Az -Scope local -Force
        }
        if (!(Get-Module -Name Az.Accounts))
        {
            Import-Module Az.Accounts -Scope local -Force
        }    
    }    
    $Global:AzureInitialized = $true
}

$Global:AzureInitialized = $false