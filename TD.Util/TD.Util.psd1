@{
    RootModule        = 'TD.Util.psm1'
    ModuleVersion     = '0.1.7'
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
            Tags = @('AzureDevOps')
            # LicenseUri = ''
            ProjectUri = 'https://github.com/ehagen/TD.Util'
            # IconUri = ''
            ReleaseNotes = '
0.1.1 - Initial version

0.1.2 - Added Add-TokensFromAzureKeyVault, Add-TokensFromConfig and Convert-TokensInFile

0.1.3 - Added access check to Register-AzureDevOpsPackageSource
      - Added force install Az modules in Add-TokensFromAzureKeyVault

0.1.4 - Updated Add-TokensFromAzureKeyVault with more diagnostics and preventing issue connecting Azure when running in Azure DevOps

0.1.5 - Refactored handling account/logged-in user to Azure in Add-TokensFromAzureKeyVault
      - Added Initialize-Azure, Test-AzureConnected, Assert-AzureConnected, Connect-ToAzure and Select-AzureSubscription
      - Added parameter validation to all functions 

0.1.7 - Renamed Select-AzureSubscription to Select-AzureDefaultSubscription
      - Added force switch to Connect-ToAzure
      - Renamed Initialize-Azure to Initialize-AzureModules
            '            
        }
    }
}