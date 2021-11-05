function Invoke-Git($Command, $WorkingDirectory)
{
    $invokeErrors = New-Object System.Collections.ArrayList 256
    $currentEncoding = [Console]::OutputEncoding
    $errorCount = $global:Error.Count
    $prevErrorActionPreference = $ErrorActionPreference
    try
    {
        $ErrorActionPreference = 'Continue'
        $LastExitCode = 0
        Invoke-Expression "git $Command" *>&1
    }
    finally
    {
        if ($currentEncoding.IsSingleByte)
        {
            [Console]::OutputEncoding = $currentEncoding
        }
        $ErrorActionPreference = $prevErrorActionPreference

        if ($global:Error.Count -gt $errorCount)
        {
            $numNewErrors = $global:Error.Count - $errorCount
            $invokeErrors.InsertRange(0, $global:Error.GetRange(0, $numNewErrors))
            if ($invokeErrors.Count -gt 256)
            {
                $invokeErrors.RemoveRange(256, ($invokeErrors.Count - 256))
            }
            $global:Error.RemoveRange(0, $numNewErrors)
            for ($i = 0; $i -lt $numNewErrors; $i++)
            {
                Write-Host "Git result $LastExitCode $($invokeErrors[$i].Exception.Message)"
            }
        }
    }
}