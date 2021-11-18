Describe 'Json Tests' {

    BeforeAll {
        . $PSScriptRoot/../TD.Util/Public/Json/Read-ObjectFromJsonFile.ps1
        . $PSScriptRoot/../TD.Util/Public/Json/Save-ObjectToJsonFile.ps1
        . $PSScriptRoot/../TD.Util/Public/Json/SecureStringStorage.ps1
        . $PSScriptRoot/../TD.Util/Public/Json/New-SecureStringStorage.ps1
        . $PSScriptRoot/../TD.Util/Public/Json/Test-IsSecureStringStorageObject.ps1
    }

    Context 'Loading and Saving Json' {

        It 'Use Secure Storage' {
            $s = [SecureStringStorage]'MySecret'
            $s.GetPlainString() | Should -Be 'MySecret'
            $s.ToString() | Should -Not -Be 'MySecret'
            $s = [SecureStringStorage]::New('MySecret')
            $s.GetPlainString() | Should -Be 'MySecret'
            $s.ToString() | Should -Not -Be 'MySecret'

            $ss = ConvertTo-SecureString -String 'MySecret' -Force -AsPlainText
            $s = [SecureStringStorage]::New($ss)
            $s.GetPlainString() | Should -Be 'MySecret'
            $s.ToString() | Should -Not -Be 'MySecret'
        }

        It 'Can Create and Test for SecureStorageObject Object' {
            $obj = New-SecureStringStorage 'Hello'
            Test-IsSecureStringStorageObject $obj | Should -Be $true
        }

        It 'Load/Save Json Object' {

            $fileName = "S(New-Guid).json"

            $object = [PSCustomObject]@{
                Name  = 'Hello'
                Title = 'World'
            }

            try
            {
                Save-ObjectToJsonFile -Path $fileName -Object $object
                Test-Path $fileName | Should -BeTrue

                $object = Read-ObjectFromJsonFile -Path $fileName
                $object.Name | Should -Be 'Hello'
                $object.Title | Should -Be 'World'
            }
            finally
            {
                Remove-Item -Path $fileName -Force -ErrorAction Ignore
            }

        }

        It 'Load/Save Secure Json Object' {

            $fileName = "S(New-Guid).json"

            $object = [PSCustomObject]@{
                Name   = 'Hello'
                Title  = 'World'
                Secret = [SecureStringStorage]'mySecret'
            }

            $object2 = [PSCustomObject]@{
                Name   = 'Hello'
                Title  = 'World'
                Secret = ConvertTo-SecureString -String 'MySecret' -Force -AsPlainText
            }

            try
            {
                Save-ObjectToJsonFile -Path $fileName -Object $object
                Test-Path $fileName | Should -BeTrue
                
                # without secret storage support --> secret scrambled
                $object = Get-Content -Path $fileName | ConvertFrom-Json -Depth 10
                $object.Name | Should -Be 'Hello'
                $object.Title | Should -Be 'World'
                $object.Secret.String | Should -Not -Be 'mySecret'

                $object = Read-ObjectFromJsonFile -Path $fileName
                $object.Name | Should -Be 'Hello'
                $object.Title | Should -Be 'World'
                $object.Secret.GetPlainString() | Should -Be 'mySecret'

                # with secure string
                Save-ObjectToJsonFile -Path $fileName -Object $object2
                $object2 = Get-Content -Path $fileName | ConvertFrom-Json -Depth 10
                $object2.Name | Should -Be 'Hello'
                $object2.Secret.TypeName | Should -Be 'SecureStringStorage'

                $object2 = Read-ObjectFromJsonFile -Path $fileName
                $object2.Title | Should -Be 'World'
                $object2.Secret.GetPlainString() | Should -Be 'mySecret'
            }
            finally
            {
                Remove-Item -Path $fileName -Force -ErrorAction Ignore
            }

        }

    }


}