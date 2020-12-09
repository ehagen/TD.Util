<#
.SYNOPSIS
Publish the PowerShell Package to the Azure Devops Feed / Artifacts

.DESCRIPTION
Publish the PowerShell Package to the Azure Devops Feed / Artifacts. Depends on nuget.exe installed and in environment path.

Strategy:
- Register feed with nuget
- Register local temp feed to use Powershell Publish-Module command
- Publish locally created module to feed with nuget.exe

.PARAMETER ModuleName
Name of the PowerShell Module to publish

.PARAMETER ModulePath
Root path of the module

.PARAMETER Feedname
Name of the Azure DevOps feed

.PARAMETER FeedUrl
Url of the Azure DevOps feed

.PARAMETER AccessToken
Personal AccessToken used for Azure DevOps Feed push/publish

.Example
Publish-PackageToAzureDevOps -ModuleName 'MyModule' -ModulePath './Output' -Feedname 'MyFeed' -FeedUrl 'https://pkgs.dev.azure.com/mycompany/_packaging/MyFeed/nuget/v2' -AccessToken 'sasasasa'

#>
function Publish-PackageToAzureDevOps($ModuleName, $ModulePath = './Output', $Feedname, $FeedUrl, $AccessToken)
{
    $packageSource = $Feedname
    $packageFeedUrl = $FeedUrl

    $deployPath = Join-Path $ModulePath $ModuleName

    # register nuget feed
    $nuGet = (Get-Command 'nuget').Source
    &$nuGet sources Remove -Name $packageSource
    [string]$r = &$nuGet sources
    if (!($r.Contains($packageSource)))
    {
        # add as NuGet feed
        Write-Verbose "Add NuGet source"
        &$nuGet sources Add -Name $packageSource -Source $packageFeedUrl -username "." -password $AccessToken
    }

    # get module version
    $manifestFile = "./$ModuleName/$ModuleName.psd1"
    $manifest = Import-PowerShellDataFile -Path $manifestFile
    $version = $manifest.Item('ModuleVersion')
    if (!$version) { Throw "No module version found in $manifestFile" } else { Write-Host "$moduleName version: $version" }

    $tmpFeedPath = Join-Path ([System.IO.Path]::GetTempPath()) "$(New-Guid)-Localfeed"
    New-Item -Path $tmpFeedPath -ItemType Directory -ErrorAction Ignore -Force | Out-Null
    try 
    {
        # register temp feed for export package
        if (Get-PSRepository -Name LocalFeed -ErrorAction Ignore)
        {
            Unregister-PSRepository  -Name LocalFeed
        }
        Register-PSRepository -Name LocalFeed -SourceLocation $tmpFeedPath -PublishLocation $tmpFeedPath -InstallationPolicy Trusted

        # publish to temp feed
        $packageName = "$moduleName.$version.nupkg"
        $package = (Join-Path $tmpFeedPath $packageName)
        Write-Verbose "Publish Module $package"
        Publish-Module -Path $deployPath -Repository LocalFeed -Force -ErrorAction Ignore
        if (!(Test-Path $package))
        {
            Throw "Nuget package $package not created"
        }

        # publish package from tmp/local feed to PS feed
        Write-Verbose "Push package $packageName in $tmpFeedPath"
        Push-Location $tmpFeedPath
        try 
        {
            nuget push $packageName -source $packageSource -Apikey Az -NonInteractive
            if ($LastExitCode -ne 0)
            {
                Throw "Error pushing nuget package $packageName to feed $packageSource ($packageFeedUrl)"
            }
        }
        finally
        {
            Pop-Location    
        }
    }
    finally 
    {
        Remove-Item -Path $tmpFeedPath -Force -Recurse
    } 
}