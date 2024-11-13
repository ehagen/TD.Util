[CmdletBinding()]
param(
    [bool]$Publish = $false
)

Set-Location $PSScriptRoot

if (-not (Get-Module -ListAvailable -Name 'Scriptbook'))
{
    Install-Module Scriptbook -Scope CurrentUser -Force -AllowClobber -Repository PSGallery
}

Import-Module Scriptbook -Force -Args @{
    Quiet   = $false
    Reset   = $false
    Depends = @(
        @{
            Module         = 'PowerShellBuild'
            MaximumVersion = '0.4.0'
            Force          = $true
        },
        @{
            Module             = 'Pester'
            Force              = $true
            SkipPublisherCheck = $true
        }
    )
}

$parameters = @{ Publish = $Publish }

Start-Scriptbook -File ./build.scriptbook.ps1 -Parameters $parameters
