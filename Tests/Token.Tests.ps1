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
            $tokens['sample-var1'] | Should -Not -BeNullOrEmpty
            $tokens['global-var4'] | Should -Not -BeNullOrEmpty
            $tokens['node-file-server'] | Should -Not -BeNullOrEmpty
            $tokens['system-user-piranha'] | Should -Not -BeNullOrEmpty

            $tokens['node-web-server'] | Should -Be "$([Environment]::MachineName)"
            $tokens['node-file-server'] | Should -Be '.'            
        }
    }

    Context 'Convert Tokens In File' {
        It 'has converted tokens in file' {
            $tokens = @{}
            Add-TokensFromConfig -ConfigPath $configRoot -Tokens $tokens -Env $environment

            New-Item "$PSScriptRoot/tmp" -ItemType Directory -Force -ErrorAction Ignore
            $fileWithTokens = "$PSScriptRoot/tmp/.fileWithTokens.xml"
            $convertedFileWithoutTokens = "$PSScriptRoot/tmp/.convertedFileWithoutTokens.xml"
            "MY File with some tokens __node-app-server__ __service-piranha__" | Set-Content -Path $fileWithTokens -Force -Encoding utf8

            Convert-TokensInFile -FileName $fileWithTokens -ShowTokensUsed -DestFileName $convertedFileWithoutTokens -Tokens $tokens

            $fc = Get-Content -Path $convertedFileWithoutTokens -Raw

            $fc.Contains('__') | Should -BeFalse
        }
    }

}