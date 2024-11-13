function Get-AdoBuildTimeline
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [ValidateNotNull()]$Id,
        [ValidateNotNull()]$TimelineId,
        $ApiVersion = '6.0'
    )

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/build/builds/$($Id)/timeline/$($TimelineId)?api-version=$ApiVersion"
    $build = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return $build
}
