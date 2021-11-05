function Wait-AdoBuildCompleted
{ 
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $Id, $TimeOut = 600, $ApiVersion = '5.0') 

    $timer = [Diagnostics.Stopwatch]::StartNew() 
    $finished = $false 
    while (!$finished) 
    { 
        Start-Sleep -Seconds 5 
        $b = Get-AdoBuild -Token $AdoAuthToken -Organization $Organization -Project $Project -Id $Id 
        if ($b.status -eq 'completed') { $finished = $true } 
        if ($timer.Elapsed.TotalSeconds -gt $TimeOut ) { Write-Warning "Build running to long $($Timeout)s, aborting waiting for build completion"; $finished = $true } 
        [Console]::Write('.') 
    } 
    $timer.Stop() 

    return $finished 
} 