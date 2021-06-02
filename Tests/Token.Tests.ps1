Describe 'token Tests' {

    BeforeAll {
        . $PSScriptRoot/../TD.Util/Public/Config/Add-TokensFromConfig.ps1
        . $PSScriptRoot/../TD.Util/Public/Config/Convert-TokensInFile.ps1

        $configRoot = './config/1.00'
        $environment = 'develop'
    }

    Context 'Validation' {
        It 'has config repo' {
            Test-Path $configRoot | Should -BeTrue
        }
    }

    Context 'Tokens From Config' {
    
        It 'has tokens' {
            $tokens = @{}
            Add-TokensFromConfig -ConfigPath $configRoot -Tokens $tokens -Env $environment

            $tokens.Keys.Count | Should -Not -Be 0

            $tokens['node-app-server'] | Should -Not -BeNullOrEmpty
            $tokens['service-piranha'] | Should -Not -BeNullOrEmpty
            $tokens['service-cert-hash-piranha'] | Should -Not -BeNullOrEmpty
            $tokens['service-healthcheck-piranha'] | Should -Not -BeNullOrEmpty
            $tokens['service-healthcheck-type-piranha'] | Should -Not -BeNullOrEmpty
            $tokens['service-healthcheck-interval-piranha'] | Should -Not -BeNullOrEmpty
            $tokens['service-type-piranha'] | Should -Not -BeNullOrEmpty
            $tokens['sample-var1'] | Should -Not -BeNullOrEmpty
            $tokens['global-var4'] | Should -Not -BeNullOrEmpty
            $tokens['node-file-server'] | Should -Not -BeNullOrEmpty
            $tokens['system-user-piranha'] | Should -Not -BeNullOrEmpty

            $tokens['node-web-server'] | Should -Be "$([Environment]::MachineName)"
            $tokens['node-file-server'] | Should -Be '.'

            $tokens['modules'].Count | Should -Not -Be 0

            $tokens['module-empty'] | Should -Not -BeNullOrEmpty
            $tokens['module-empty-role'] | Should -Not -BeNullOrEmpty
            $tokens['module-empty-depends'] | Should -Not -BeNull
            $tokens['module-empty-folder'] | Should -Not -BeNullOrEmpty

            $tokens['module-sample'] | Should -Not -BeNullOrEmpty
            $tokens['module-sample-role'] | Should -BeNullOrEmpty
            $tokens['module-sample-depends'] | Should -BeNullOrEmpty
            $tokens['module-sample-folder'] | Should -BeNullOrEmpty

            $tokens['module-piranha'] | Should -Not -BeNullOrEmpty
            $tokens['module-piranha-role'] | Should -Not -BeNullOrEmpty
            $tokens['module-piranha-depends'] | Should -BeNullOrEmpty
            $tokens['module-piranha-folder'] | Should -Not -BeNullOrEmpty

            $tokens['module-piranha-application-piranha'] | Should -Not -BeNullOrEmpty
            $tokens['module-piranha-application-piranha-type'] | Should -Not -BeNullOrEmpty
            $tokens['module-piranha-application-piranha-role'] | Should -Not -BeNullOrEmpty
            $tokens['module-piranha-application-piranha-exe'] | Should -Not -BeNullOrEmpty
            $tokens['module-piranha-application-piranha-dotnet-version'] | Should -Not -BeNullOrEmpty            

            $tokens['module-piranha-application-piranha2'] | Should -Not -BeNullOrEmpty
            $tokens['module-piranha-application-piranha2-type'] | Should -Not -BeNullOrEmpty
            $tokens['module-piranha-application-piranha2-role'] | Should -Not -BeNullOrEmpty
            $tokens['module-piranha-application-piranha2-exe'] | Should -Not -BeNullOrEmpty
            $tokens['module-piranha-application-piranha2-dotnet-version'] | Should -Not -BeNullOrEmpty

            $tokens = @{}
            Add-TokensFromConfig -ConfigPath $configRoot -Tokens $tokens -Env $environment -Module piranha

            $tokens.Keys.Count | Should -Not -Be 0

            $tokens['module-empty'] | Should -BeNullOrEmpty
            $tokens['module-sample'] | Should -BeNullOrEmpty
            $tokens['module-piranha-application-piranha'] | Should -Not -BeNullOrEmpty

        }
    }

    Context 'Convert Tokens In File' {
        It 'has converted tokens in file' {
            $tokens = @{}
            Add-TokensFromConfig -ConfigPath $configRoot -Tokens $tokens -Env $environment
            $tokens.Add('WITHCURLY','MyTOK{WITH}')

            New-Item "$PSScriptRoot/tmp" -ItemType Directory -Force -ErrorAction Ignore
            $fileWithTokens = "$PSScriptRoot/tmp/.fileWithTokens.xml"
            $convertedFileWithoutTokens = "$PSScriptRoot/tmp/.convertedFileWithoutTokens.xml"
            "MY File with some tokens __node-app-server__ __service-piranha__ __WITHCURLY__" | Set-Content -Path $fileWithTokens -Force -Encoding utf8

            Convert-TokensInFile -FileName $fileWithTokens -ShowTokensUsed -DestFileName $convertedFileWithoutTokens -Tokens $tokens

            $fc = Get-Content -Path $convertedFileWithoutTokens -Raw

            $fc.Contains('__') | Should -BeFalse
        }
    }

}