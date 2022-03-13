function Get-AdoBuildLogs
{ 
    param(
        [ValidateNotNullOrEmpty()][alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [ValidateNotNull()]$Id, $ApiVersion = '6.0'
    )

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/build/builds/$($Id)/logs?api-version=$ApiVersion"
    $logs = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return , $logs.value
} 