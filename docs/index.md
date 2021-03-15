# Welcome

This module contains a collection of general utility functions for PowerShell, Azure, Azure DevOps and Slack. See below for some scenarios

[![Release Notes](https://img.shields.io/badge/-Release%20Notes-black.svg?longCache=true&style=for-the-badge)](./release-notes.md)

## On Windows get Azure DevOps credentials (PAT) from Git repo

```powershell
$credential = Get-AzureDevOpsCredential -Url 'https://!company!@dev.azure.com/!company!'
```

## Register Azure DevOps private Artifacts Feed (package-source) & import modules from this Artifacts Feed

```powershell
Register-AzureDevOpsPackageSource -Name 'MyCustomFeedName' -Url 'https://pkgs.dev.azure.com/!company!/_packaging/!feedname!/nuget/v2' -Credential $credential
Import-AzureDevOpsModules -PackageSource 'MyCustomFeedName' -Modules @('module1','module2') -Credential $credential -Latest
```

## Register Azure DevOps private Artifacts Feed (package-source) & import modules from this Artifacts Feed

```powershell
Register-AzureDevOpsPackageSource -Name 'MyCustomFeedName' -Url 'https://pkgs.dev.azure.com/!company!/_packaging/!feedname!/nuget/v2' -Credential $credential
Import-AzureDevOpsModules -PackageSource 'MyCustomFeedName' -Modules @('module1','module2') -Credential $credential -Latest
```

## Publish Package to private Azure DevOps Artifacts Feed

```powershell
Publish-PackageToAzureDevOps -ModuleName 'MyModule' -ModulePath './Output' -Feedname 'MyCustomFeedName' -FeedUrl 'https://pkgs.dev.azure.com/!company!/_packaging/!feedname!/nuget/v2' -AccessToken 'sasasasa'
```

## Get Secrets from Azure Keyvault

```powershell
$Tokens = @{}
Add-TokensFromAzureKeyVault -Vault 'MyVaultName' -Tokens $Tokens -SubscriptionId 'mySubscriptionId'
```

## Send message to Slack
[See here](./Functions/Slack/Send-ToSlack.md)
