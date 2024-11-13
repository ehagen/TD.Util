function Get-AdoBuildLog
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [ValidateNotNull()]$Id,
        [ValidateNotNull()]$LogId,
        $ApiVersion = '7.0'
    )

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/build/builds/$($Id)/logs/$($LogId)?api-version=$ApiVersion"
    $log = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return $log
}
