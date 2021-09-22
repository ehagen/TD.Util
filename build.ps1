[CmdletBinding()]
param(
    [bool]$Publish = $true
)

if (-not (Get-Module -ListAvailable -Name 'Scriptbook')) 
{
    Install-Module Scriptbook -Scope CurrentUser -Force -AllowClobber -Repository PSGallery
}

Import-Module Scriptbook -Force -Args @{ 
    Quiet   = $false
    Reset   = $false
    Depends = @(
        @{
            Module = 'PowerShellBuild'
            Force  = $true
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