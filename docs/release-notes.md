# Release Notes

![PowerShell Gallery](https://img.shields.io/powershellgallery/v/td.util.svg?label=PSGallery%20Version&logo=PowerShell&style=flat-square)
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/td.util.svg?label=PSGallery%20Downloads&logo=PowerShell&style=flat-square)
[![Build Status](https://dev.azure.com/tedon/TD.Deploy/_apis/build/status/ehagen.TD.Util?branchName=master)](https://dev.azure.com/tedon/TD.Deploy/_build/latest?definitionId=52&branchName=master)

## [0.1.35] - 2023-07-05

```plain
### Added
- Added Get-AdoProjectBuilds Scanning detection option and fixed undeclared vars

## [0.1.34] - 2023-06-28

```plain
### Added
- Added AdoPipeline functions
- Added AdoBuild functions
- Added AdoProject function

## [0.1.33] - 2023-02-04

```plain
### Added
- Added Invoke-AdoQueuePipeline

## [0.1.32] - 2022-12-03

```plain
### Added
- Added Get-AdoPools
- Added Add-AdoPool
- Added Remove-AdoPool
- Added Update-AdoPool
- Added Write-Header & Write-Params & Write-HostDetails for logging & debugging purpose

```

## [0.1.31] - 2022-11-19

```plain
### Added
- Added Get-AdoEnvironments
- Added Add-AdoEnvironment
- Added Remove-AdoEnvironment
- Added Update-AdoEnvironment

```

## [0.1.30]

```plain
### Added
- Added Get-AdoBuildTimeline
- Added Get-AdoPipelineApprovals
- Added Get-AdoPipelineChecks
- Added Get-AdoPipelinePendingApprovals
- Added Get-AdoReleaseApprovals
- Added Update-AdoPipelineApproval

### Changed
- Added StatusFilter to Get-AdoBuilds

```

## [0.1.29]

```plain
### Added
- Added Get-AdoBuilds
- Added Get-AdoBuildLog
- Added Get-AdoBuildLogs
- Added Get-AdoBuildOutput
- Added Get-UniqueId

```

## [0.1.28]

```plain
### Added
- Added secret alternative name support by using KeyVault Secrets Tags 'alt-name', additional second token is created with this name. Use to circumvent Azure KeyVault Secret name character restrictions

```

## [0.1.27]

```plain
### Added
- Added support for Certs by Name on service nodes
```

## [0.1.26]

```plain
### Added
- Added Copy-ObjectPropertyValues
- Added Ado Get-AdoRepositoryPolicy
- Added Utility functions Convert-ObjectToHashTable, ConvertTo-TitleCase, Copy-ObjectPropertyValues, Get-ArrayItemCount, Get-RandomString and Merge-Objects

### Changed

- Improved saving Json file with SecureStringStorage

```

## [0.1.25]

```plain
### Added
- Added New-SecureStringStorage and test for type SecureStringStorage

```

## [0.1.24]

```plain
### Added
- Added more Ado functions
- Added Json Loading and Save functions with simple secret storage support

```

## [0.1.23]

```plain
### Added
- Added Import-Module Quiet option

```

## [0.1.22]

```plain
### Added
- Added Ado Rest wrapper functions from TD.Deploy
- Added Git Invoke and Clone functions
- Added Invoke-Retry function

```

## [0.1.21]

```plain
### Added
- Added support for Set-StrictMode -Latest
- Added Get-PSPropertyValue
- Added Test-PSProperty
- Added Get-EnvironmentVar

### Changed

- Fixed handling errors when retrieving secrets via Get-AzKeyVaultSecret
- Updated build.ps1 to use Scriptbook Module (No psake required anymore)

```

## [0.1.19]

```plain
### Added

- Added relation between Module and Application. Enables Module lookup for application

### Changed

- Improved output Convert-TokensInFile
- Improved error message Register-AzureDevOpsPackageSource when invalid PSRepositories.xml detected
- Improved error message Add-TokensFromAzureKeyVault when Forbidden access to Vault exception occurs
```

## [0.1.18]

```plain
### Fixed

- Fixed PSGallery tag requirements, no space allowed :)
```

## [0.1.17]

```plain
### Added

- Added check running on windows platform for Get-AzureDevOpsAccessToken and Get-AzureDevOpsCredential
- Added Unregister tempfeed (Localfeed)
- Added More Verbose output to aid debugging
```

## [0.1.15]

```plain
### Added

- Added Service HealthCheck settings from Config
- Added tests results to Azure Pipeline
```

## [0.1.14]

```plain
### Added
- Added Module and Application settings from Config
- Added multiple module files support to Config

### Changed

### Fixed
```

## [0.1.12]

```plain
### Added
- Added secrets support to Convert-TokensInFile

### Changed

### Fixed
```

## [0.1.11]

```plain
### Added
- Added Send-ToSlack
- Added tests (work in progress)
- Added docs (work in progress)
- Added code signing

### Changed

### Fixed
```

## [0.1.10]

```plain
### Added

### Changed
- Renamed psake files to build.ps1 and build.psake.ps1

### Fixed
- Fix Register-AzureDevOpsPackageSource url check ps 5.1
```

## [0.1.9]

```plain
### Added
- Added Pester tests tokens/config
- Added token service cert-hash and current machine name support

### Changed

### Fixed
```

## [0.1.8]

```plain
### Added
- Added install/import module Az.KeyVault
- Added support for disabled keyvault secrets

### Changed

### Fixed
- Fixed loginfo issue Convert-TokensInFile
```

## [0.1.7]

```plain
### Added
- Added force switch to Connect-ToAzure

### Changed
- Renamed Select-AzureSubscription to Select-AzureDefaultSubscription
- Renamed Initialize-Azure to Initialize-AzureModules

### Fixed
```

## [0.1.5]

```plain
### Added
- Added Initialize-Azure, Test-AzureConnected, Assert-AzureConnected, Connect-ToAzure and Select-AzureSubscription
- Added parameter validation to all functions

### Changed
- Refactored handling account/logged-in user to Azure in Add-TokensFromAzureKeyVault

### Fixed
```

## [0.1.4]

```plain
### Added

### Changed
- Updated Add-TokensFromAzureKeyVault with more diagnostics and preventing issue connecting Azure when running in Azure DevOps

### Fixed
```

## [0.1.3]

```plain
### Added
- Added access check to Register-AzureDevOpsPackageSource
- Added force install Az modules in Add-TokensFromAzureKeyVault

### Changed

### Fixed
```

## [0.1.2]

```plain
### Added
- Added Add-TokensFromAzureKeyVault, Add-TokensFromConfig and Convert-TokensInFile

### Changed

### Fixed
```

## [0.1.1]

```plain
### Added
- Initial version

### Changed

### Fixed
```

The format is based on [Keep a Changelog](http://keepachangelog.com/)
