<#
.SYNOPSIS
PSake bootstrap script to start the build.psake.ps1
#>
param(
    $Publish = $false
)

if (-not (Get-Module PSake -ListAvailable)) { Install-Module PSake -Repository PSGallery -Force }
if (-not (Get-Module PowerShellBuild -ListAvailable)) { Install-Module PowerShellBuild -AllowClobber -Force }
if (-not (Get-Module Pester -ListAvailable)) { Install-Module Pester -AllowClobber -Force -SkipPublisherCheck }

Import-Module PSake
Import-Module PowerShellBuild
Import-Module Pester

$psakeParameters = @{Publish = $Publish}

Invoke-psake -buildFile './build.psake.ps1' -nologo -parameters $psakeParameters -properties $psakeParameters
exit ([int](-not $psake.build_success))