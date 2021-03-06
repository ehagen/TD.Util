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
        Write-Host "Installing Az modules, can take some time."
        Install-Module -Name Az -AllowClobber -Scope CurrentUser -Repository PSGallery -Force
    }
    else
    {
        if (!(Get-Module -Name Az))
        {
            Import-Module Az -Scope local -Force
        }
    }    
    if ($null -eq (Get-Module -ListAvailable 'Az.Accounts'))
    {
        Install-Module -Name Az.Accounts -AllowClobber -Scope CurrentUser -Repository PSGallery -Force
    }
    else
    {
        if (!(Get-Module -Name Az.Accounts))
        {
            Import-Module Az.Accounts -Scope local -Force
        }    
    }    
    if ($null -eq (Get-Module -ListAvailable 'Az.KeyVault'))
    {
        Install-Module -Name Az.KeyVault -AllowClobber -Scope CurrentUser -Repository PSGallery -Force
    }
    else
    {
        if (!(Get-Module -Name Az.KeyVault))
        {
            Import-Module Az.KeyVault -Scope local -Force
        }    
    }    
    $Global:AzureInitialized = $true
}

$Global:AzureInitialized = $false