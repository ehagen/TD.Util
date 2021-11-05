function Invoke-RetryBlock([alias('c', 'Code')][ScriptBlock]$ScriptBlock, [alias('r', 'Retry')][int]$RetryCnt = 3, [alias('w', 'WaitSec', 'DelaySec')][int]$RetryDelaySec = 5, [switch][bool]$NoException, [alias('Msg', 'm')]$Message, [alias('mn')]$MutexName = $null)
{
    $stopLoop = $false
    [int]$retryCount = 1
    $m = $null

    if ($MutexName)
    {
        $m = Wait-OnMutex -Name $MutexName
    }
    try
    {
        do
        {
            try
            {
                Invoke-Command -ScriptBlock $ScriptBlock -ErrorAction Stop
                $stopLoop = $true
            }
            catch
            {
                if ($retryCount -ge $RetryCnt)
                {
                    $stopLoop = $true
                    if (!($NoException.IsPresent))
                    {
                        Write-Verbose "Retry block failed after $RetryCnt retries with delay of $RetryDelaySec";
                        Throw
                    }
                }
                else
                {
                    $retryCount ++
                    if ($Message)
                    {
                        Write-Host "$Message retry '$retryCount' delay $($RetryDelaySec)s"
                    }
                    else
                    {
                        Write-Verbose "In retry '$retryCount' with delay of $($RetryDelaySec)s"
                    }
                    Write-Verbose $_.Exception.Message
                    Start-Sleep -Seconds $RetryDelaySec
                }
            }
        }
        while (!$stopLoop)
    }
    finally
    {
        if ($m)
        {
            Exit-Mutex $m
            Close-Mutex $m
        }
    }
}