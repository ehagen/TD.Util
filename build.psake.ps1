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
Task default -depends `
    Build, `
    TestWithCoverage, `
    PublishModule

Task TestWithCoverage -depends Build {
    Push-Location .\Tests
    try
    {
        Invoke-Pester -Script "." -OutputFile "./Test-Pester.XML" -OutputFormat 'NUnitXML' -CodeCoverage "../TD.Util/*.ps1"
    }
    finally
    {
        Pop-Location
    }
}

Task PublishModule -depends Test {
    if ($false)
    {
        Publish-Module -Path (Join-Path $PSScriptRoot 'Output/TD.Util') -NuGetApiKey $env:PsGalleryApiKey #-WhatIf -Verbose
        Write-Host 'Published to https://www.powershellgallery.com/packages/TD.Util'
    }
}