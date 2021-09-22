<#
.SYNOPSIS
Powershell Module build script

.DESCRIPTION
This script uses the default PowershellBuild commands to build and publish the Module
#>
param(
    $Actions,
    $Parameters = @{ Publish = $false }
)

Task Build -FromModule PowerShellBuild

$PSBPreference.Build.CompileModule = $true
$PSBPreference.Test.ScriptAnalysisEnabled = $true
$PSBPreference.Test.CodeCoverage.Enabled = $true
$PSBPreference.Test.ScriptAnalysis.SettingsPath = './Tests/ScriptAnalyzerSettings.psd1'
$PSBPreference.Docs.RootDir = "./output/gen-docs"    
$publish = $Parameters.Publish

Task EnvironmentInfo {
    Write-Host ""
    Write-Host "Environment Info:"
    Write-Host "     Computer: $([system.environment]::MachineName)"
    Write-Host "           Os: $([System.Environment]::OSVersion.VersionString)"
    Write-Host "       WhoAmI: $([Environment]::UserName)"
    Write-Host "   Powershell: $($PSVersionTable.PsVersion)"
    Write-Host "CurrentFolder: $(Get-Location)"
    Write-Host ""
}

Task EnvironmentVariables {
    Get-ChildItem env:
}
    
Task Sign -Depends Build {
    $cert = $null
    if ( (!!$env:SYSTEM_TEAMPROJECT) -and ( $IsWindows) )
    {
        $certLoc = "$($env:AGENT_WORKFOLDER)/_temp/code-signing-cert.pfx"
        try
        {
            $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($certLoc, $env:CertPassword);
            Write-Host "Loaded signing cert";
        }
        catch
        {
            Write-Host "Unable to load certificate from '$certLoc'" + $_
        }
    }
    if ( (!$cert) -and ( $IsWindows) )
    {
        $cert = Get-ChildItem -Path "Cert:\CurrentUser\My" -CodeSigningCert -ErrorAction Ignore | Sort-Object NotAfter | Select-Object -First 1
    }
    if ($cert)
    {
        Get-ChildItem (Join-Path $($env:BHBuildOutput) '.\TD.Util.*') | Set-AuthenticodeSignature -Certificate $cert -TimestampServer 'http://timestamp.digicert.com'
    }
}

Task TestWithCoverage -depends Build {
    Push-Location .\Tests
    try
    {
        Invoke-Pester -Script "." -OutputFile "./Test-Pester.XML" -OutputFormat 'NUnitXML' #-CodeCoverage "../TD.Util/*.ps1"
    }
    finally
    {
        Pop-Location
    }
}

Task BuildMKDocs -PreCondition { $Publish } {
    $moduleName = 'TD.Util'
    Remove-Module $moduleName -Force -ErrorAction Ignore | Out-Null

    $path = './docs/Functions'
    New-Item -Path $path -ItemType Directory -Force -ErrorAction Ignore
    $map = @{}

    if ($PSBPreference.Build.CompileModule)
    {
        $manifest = Import-PowerShellDataFile -Path "./$moduleName/$moduleName.psd1"
        $version = $manifest.Item('ModuleVersion')
        Import-Module "./Output/$moduleName/$version/$moduleName.psm1" -Force -Scope Global | Out-Null

        # this has no support for type folders
        #New-MarkdownHelp -Module $moduleName -OutputFolder $path -Force -Metadata @{ } -AlphabeticParamsOrder | Out-Null

        $dotSourceParams = @{
            Filter      = '*.ps1'
            Recurse     = $true
            ErrorAction = 'Stop'
        }
        $public = @(Get-ChildItem -Path (Join-Path -Path $moduleName -ChildPath 'public') @dotSourceParams )
        
        (Get-Module $moduleName).ExportedFunctions.Keys | ForEach-Object {
            try
            {
                $func = $_
                $fn = $public | Where-Object { $_.Name -eq "$func.ps1"}
                $type = [System.IO.Path]::GetFileNameWithoutExtension((Split-Path -Leaf -Path (Split-Path -Parent -Path $fn)))
                New-MarkdownHelp -Command $func -OutputFolder (Join-Path $path $type) -Force -Metadata @{ } | Out-Null
                $map[$func] = $type
            }
            catch
            {
                Throw "Error generating documentation for function $func"
            }
        }
    }
    else
    {
        Import-Module "./$moduleName/$moduleName.psm1" -Force -Scope Global | Out-Null
        (Get-Module $moduleName).ExportedFunctions.Keys | ForEach-Object {
            try
            {
                $func = $_
                $type = [System.IO.Path]::GetFileNameWithoutExtension((Split-Path -Leaf -Path (Split-Path -Parent -Path (Get-Command $func -Module $moduleName).ScriptBlock.File)))
                New-MarkdownHelp -Command $func -OutputFolder (Join-Path $path $type) -Force -Metadata @{ } | Out-Null
                $map[$func] = $type
            }
            catch
            {
                Throw "Error generating documentation for function $func"
            }
        }
    }

    # update docs to bind links to unlinked functions
    $path = Join-Path $pwd 'docs'
    Get-ChildItem -Path $path -Recurse -Filter '*.md' | ForEach-Object {
        $depth = ($_.FullName.Replace($path, [string]::Empty).trim('\/') -split '[\\/]').Length

        $content = (Get-Content -Path $_.FullName | ForEach-Object {
                $line = $_
                while ($line -imatch '\[`(?<name>[a-z]+\-deploy[a-z]+)`\](?<char>[^(])')
                {
                    $name = $Matches['name']
                    $char = $Matches['char']
                    $line = ($line -ireplace "\[``$($name)``\][^(]", "[``$($name)``]($('../' * $depth)Functions/$($map[$name])/$($name))$($char)")
                }
                $line
            })

        $content | Out-File -FilePath $_.FullName -Force -Encoding ascii
    }

    Remove-Module $moduleName -Force -ErrorAction Ignore | Out-Null

    if (!(Get-Command mkdocs -ErrorAction Ignore))
    {
        if ($IsWindows)
        {
            if (Get-Command choco -ErrorAction Ignore)
            {
                choco install mkdocs -y --no-progress
                pip install "mkdocs-material==6.2.8" --force-reinstall --disable-pip-version-check
            }
            else
            {
                Throw "Choco not found, cannot install MKDocs"
            }
        }
        elseif ($IsMacOS)
        {
            brew install mkdocs
            pip3 install "mkdocs-material==6.2.8" --force-reinstall --disable-pip-version-check
        }
        else
        {
            Throw "MKDocs not supported on this operating system (Linux)"
        }
    }

    mkdocs build
}

Task PublishModule -PreCondition { $Publish } {
    if ($env:PsGalleryApiKey)
    {
        Publish-Module -Path (Join-Path $PSScriptRoot 'Output/TD.Util') -NuGetApiKey $env:PsGalleryApiKey #-WhatIf -Verbose
        Write-Host 'Published to https://www.powershellgallery.com/packages/TD.Util'
    }
}

Task default -depends `
    EnvironmentInfo, `
    EnvironmentVariables, `
    Build, `
    Sign, `
    TestWithCoverage, `
    BuildMKDocs, `
    PublishModule