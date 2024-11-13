function Wait-AdoBuildCompleted
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [ValidateNotNull()]$Id,
        $TimeOut = 600,
        $ApiVersion = '5.0'
    )

    $timer = [Diagnostics.Stopwatch]::StartNew()
    $finished = $false
    while (!$finished)
    {
        Start-Sleep -Seconds 5
        $b = Get-AdoBuild -Token $AdoAuthToken -Organization $Organization -Project $Project -Id $Id
        if ($b.status -eq 'completed')
        {
            $finished = $true
        }
        elseif ($timer.Elapsed.TotalSeconds -gt $TimeOut)
        {
            Write-Warning "Build running to long $($Timeout)s, aborting wait for build completion"
            $finished = $true
        }
        [Console]::Write('.')
    }
    $timer.Stop()

    return $finished
}
