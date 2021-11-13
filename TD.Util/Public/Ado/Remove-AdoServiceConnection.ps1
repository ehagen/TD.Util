function Remove-AdoServiceConnection
{
    [CmdletBinding()]
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $ApiVersion = '6.0-preview.4', $Organization, $ProjectIds, $EndPointId, [switch]$DeleteSpn)

    $url = "$(Get-AdoUri -Uri $AdoUri -Project '' -Organization $Organization)/_apis/serviceendpoint/endpoints/$($EndpointId)?projectIds=$($ProjectIds)&deep=$($DeleteSpn.IsPresent)&api-version=$ApiVersion"
    Invoke-RestMethod -Method Delete -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
}