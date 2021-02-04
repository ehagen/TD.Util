<#
.SYNOPSIS
PSake bootstrap script to start the psakefile.ps1
#>

if (-not (Get-Module PSake -ListAvailable)) { Install-Module PSake -Repository PSGallery -Force }
if (-not (Get-Module PowerShellBuild -ListAvailable)) { Install-Module PowerShellBuild -AllowClobber -Force }
if (-not (Get-Module PowerShellBuild -ListAvailable)) { Install-Module Pester -AllowClobber -Force -SkipPublisherCheck }

Import-Module PSake
Import-Module PowerShellBuild
Import-Module Pester

Invoke-psake -buildFile './psakeFile.ps1' -nologo
exit ([int](-not $psake.build_success))