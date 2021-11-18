Describe 'Utility Tests' {

    BeforeAll {
        . $PSScriptRoot/../TD.Util/Public/Utilities/ConvertTo-TitleCase.ps1
        . $PSScriptRoot/../TD.Util/Public/Utilities/Get-RandomString.ps1
        . $PSScriptRoot/../TD.Util/Public/Utilities/Get-ArrayItemCount.ps1
        . $PSScriptRoot/../TD.Util/Public/Utilities/Convert-ObjectToHashTable.ps1
        . $PSScriptRoot/../TD.Util/Public/Utilities/Merge-Objects.ps1
        . $PSScriptRoot/../TD.Util/Public/Utilities/Copy-ObjectPropertyValues.ps1
    }

    Context 'Utility functions' {

        It 'Can Copy properties from one object to another' {

            $from = [PSCustomObject]@{
                Name  = 'Hello'
                World = $true
            }
            $to = [PSCustomObject]@{
                Name = 'World'
            }
            $o = Copy-ObjectPropertyValues $from $to

            $o.Name | Should -Be 'Hello'
            $o.PSObject.Properties.Count | Should -Be 1
        }

        It 'Can Convert string to title Case' {
            $s = ConvertTo-TitleCase 'hello world'
            $s -ceq 'Hello World' | Should -Be $true
        }

        It 'Can get RandomString' {
            $s = Get-RandomString 40
            $s.Length | Should -Be 40
        }

        It 'Can get ArrayCount' {
            $a = @(1, 2, 3)
            Get-ArrayItemCount $a | Should -Be 3
            $a = @()
            Get-ArrayItemCount $a | Should -Be 0
            $a = 'hello'
            Get-ArrayItemCount $a | Should -Be 1
            $a = New-Object System.Collections.ArrayList 256
            [void]$a.Add('1')
            [void]$a.Add('2')
            Get-ArrayItemCount $a | Should -Be 2
        }

        It 'Can convert PSObject to HashTable' {
            # arrange
            $o = [PSCustomObject]@{
                Name1 = 'Value1'
                Name2 = 'Value2'
                Name3 = [PsCustomObject]@{
                    Name4 = 'Value4'
                    Name5 = 5
                }
            }

            # act
            $h = Convert-ObjectToHashTable $o

            # assert
            $h.Name1 -eq 'Value1' | Should -Be $true
            $h.Name3.Name5 -eq 5 | Should -Be $true
        }

        It 'Can merge objects' {

            $o = [PSCustomObject]@{
                Name1 = 'Value1'
                Name2 = 'Value2'
                Name3 = [PsCustomObject]@{
                    Name4 = 'Value4'
                    Name5 = 5
                }
            }
            $o2 = [PSCustomObject]@{
                Name6 = 'Value6'
                Name7 = 'Value7'
                Name8 = [PsCustomObject]@{
                    Name9  = 'Value9'
                    Name10 = 10
                }
            }
            $o3 = [PSCustomObject]@{
                Name1 = 'Value1111'
                Name3 = [PsCustomObject]@{
                    Name5 = 5555
                }
            }
            $newObject = Merge-Objects $o, $o2, $o3
            $newObject.Name1 | Should -Be 'Value1'
            $newObject.Name3.Name5 | Should -Be 5
            $newObject.Name7 | Should -Be 'Value7'
            $newObject.Name8.Name10 | Should -Be 10
        }

    }
}