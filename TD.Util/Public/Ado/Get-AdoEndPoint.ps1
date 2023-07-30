function Get-AdoEndPoint
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        $Organization,
        $Project,
        $Id,
        $ApiVersion = '7.0'
    )

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/serviceendpoint/endpoints/$($Id)?api-version=$ApiVersion"
    $endpoint = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return $endpoint
}