@{
    RootModule        = 'TD.Util.psm1'
    ModuleVersion     = '0.1.2'
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
            '
        }
    }
}