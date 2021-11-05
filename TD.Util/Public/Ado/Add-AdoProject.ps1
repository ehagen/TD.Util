function Add-AdoProject
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $ApiVersion = '5.0', $Organization, $Project, $Description, [switch]$Wait)

    $url = "$(Get-AdoUri $AdoUri '' $Organization)/_apis/projects?api-version=$ApiVersion"

    $request = @{
        name         = $Project
        description  = $Description
        capabilities = @{
            versioncontrol  = @{
                sourceControlType = 'Git'
            }
            processTemplate = @{
                templateTypeId = '6b724908-ef14-45cf-84f8-768b5384da45'
            }
        }
    }

    $body = $request | ConvertTo-Json -Depth 10 -Compress
    
    $result = Invoke-RestMethod -Method Post -Uri $url -Body $body -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60

    if ($Wait.IsPresent)
    {
        $timeOut = 60 * 5
        $url = $result.url
        $timer = [Diagnostics.Stopwatch]::StartNew() 
        $finished = $false 
        while (!$finished) 
        { 
            Start-Sleep -Seconds 5 
            $o = Invoke-RestMethod -Method Get -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60
            if ($o.status -eq 'succeeded') { $finished = $true } 
            if ($timer.Elapsed.TotalSeconds -gt $timeOut ) { Write-Warning "Project creation to long $($timeout)s"; $finished = $true } 
            #[Console]::Write('.') 
        } 
        $timer.Stop() 
    }
    
    return $result
}