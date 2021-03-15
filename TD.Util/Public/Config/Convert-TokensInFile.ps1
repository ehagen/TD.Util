<#
.SYNOPSIS
Convert the tokens in file to their actual values

.DESCRIPTION
Convert the tokens in file to their actual values

.PARAMETER FileName
Name of the file to convert

.PARAMETER PrefixToken
Token prefix

.PARAMETER SuffixToken
Token suffix

.PARAMETER DestFileName
File name of converted file

.PARAMETER ShowTokensUsed
Switch to echo tokens replaced

.PARAMETER SecondPass
Switch to signal that same file is used in multiple conversions

.PARAMETER Tokens
Hashtable to add tokens to

.Example
$Tokens = @{}
Add-TokensFromConfig -ConfigPath "$PSScriptRoot/config" -Tokens $Tokens -Env 'local'

Get-ChildItem .\$ConfigLocation\*.* | ForEach-Object {
    $destFile = Join-Path $ArtifactsLocation $_.Name
    Convert-TokensInFile -FileName $_.Fullname -DestFileName $destFile -Tokens $Tokens
}

#>
function Convert-TokensInFile([Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$FileName, $PrefixToken = '__', $SuffixToken = '__', $DestFileName, [Switch]$ShowTokensUsed, [Switch]$SecondPass, $Tokens)
{
    if (!$DestFileName) { $DestFileName = $FileName }

    if (Test-Path $FileName)
    {
        $regex = [regex] "${PrefixToken}((?:(?!${SuffixToken}).)*)${SuffixToken}"
        $content = [System.IO.File]::ReadAllText($FileName);
        if (!$Tokens) 
        {
            $Tokens = @{}
        }
        $script:cnt = 0
        $callback = {
            param([System.Text.RegularExpressions.Match] $Match)
            $value = $Match.Groups[1].Value

            # check env first
            $newTokenValue = [Environment]::GetEnvironmentVariable($value)
            if ($null -eq $newTokenValue)
            {
                if ($Tokens.ContainsKey($value))
                {
                    $newTokenValue = $Tokens[$value]

                    # detect expression in variable
                    if ($newTokenValue.ToString().StartsWith('$'))
                    {
                        $newTokenValue = Invoke-Expression "Write-Output `"$($newTokenValue)`""
                    }                    
                }
            }
            if ($null -eq $newTokenValue)
            {
                $script:HasReplaceVarErrors = $true;
                Write-Warning "Token not found in replace: '$value'"
                return ""
            }

            $script:cnt++
            if ($ShowTokensUsed.IsPresent -or ($Global:VerbosePreference -eq 'Continue'))
            {
                Write-Host "Replacing token '$value' with '$newTokenValue'"
            }
            return $newTokenValue
        }

        $content = $regex.Replace($content, $callback)

        New-Item -ItemType Directory (Split-Path -Path $DestFileName) -Force -ErrorAction Ignore | Out-Null
        Set-Content -Path $DestFileName -Value $content -Encoding UTF8

        if ($Global:VerbosePreference -eq 'Continue')
        {
            if ($SecondPass.IsPresent -and ($script:cnt -eq 0) )
            {
                #ignore
            }
            else
            {
                Write-Host "Tokens replaced: $($script:cnt)"
            }
        }

    }
    else
    {
        Throw "Convert-TokensInFile error file not found '$FileName'"
    }
}