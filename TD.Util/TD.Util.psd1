@{
      RootModule        = 'TD.Util.psm1'
      ModuleVersion     = '0.1.10'
      GUID              = '62f2ff10-4b3c-4464-b863-e7352e07468e'
      Author            = 'Edwin Hagen'
      CompanyName       = 'Tedon Technology BV'
      Copyright         = '(c) Tedon Technology BV. All rights reserved.'
      Description       = 'Tedon Util module'
      PowerShellVersion = '3.0'
      RequiredModules   = @()
      FunctionsToExport = '*'
      CmdletsToExport   = @()
      VariablesToExport = @()
      AliasesToExport   = @()
      PrivateData       = @{
            PSData = @{
                  Tags         = @('AzureDevOps')
                  # LicenseUri = ''
                  ProjectUri   = 'https://github.com/ehagen/TD.Util'
                  # IconUri = ''
                  ReleaseNotes = '
0.1.1  - Initial version

0.1.2  - Added Add-TokensFromAzureKeyVault, Add-TokensFromConfig and Convert-TokensInFile

0.1.3  - Added access check to Register-AzureDevOpsPackageSource
       - Added force install Az modules in Add-TokensFromAzureKeyVault

0.1.4  - Updated Add-TokensFromAzureKeyVault with more diagnostics and preventing issue connecting Azure when running in Azure DevOps

0.1.5  - Refactored handling account/logged-in user to Azure in Add-TokensFromAzureKeyVault
       - Added Initialize-Azure, Test-AzureConnected, Assert-AzureConnected, Connect-ToAzure and Select-AzureSubscription
       - Added parameter validation to all functions 

0.1.7  - Renamed Select-AzureSubscription to Select-AzureDefaultSubscription
       - Added force switch to Connect-ToAzure
       - Renamed Initialize-Azure to Initialize-AzureModules

0.1.8  - Added install/import module Az.KeyVault
       - Fixed loginfo issue Convert-TokensInFile
       - Added support for disabled keyvault secrets

0.1.9  - Added Pester tests tokens/config
       - Added token service cert-hash and current machine name support

0.1.10 - Fix Register-AzureDevOpsPackageSource url check ps 5.1
       - Renamed psake files to build.ps1 and build.psake.ps1

'            
            }
      }
}