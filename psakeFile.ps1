<#
.SYNOPSIS
Powershell Module build script

.DESCRIPTION
This script uses the default PowershellBuild commands to build and publish the Module
#>

Properties {
    $PSBPreference.Build.CompileModule = $true
}

Task Build -FromModule PowerShellBuild
Task default -depends PublishModule

Task PublishModule -depends Build {
    if ($false)
    {
        Publish-Module -Path (Join-Path $PSScriptRoot 'Output/TD.Util') -NugetAPIKey $env:PsGalleryApiKey #-WhatIf -Verbose
        Write-Host 'Published to https://www.powershellgallery.com/packages/TD.Util'
    }
}