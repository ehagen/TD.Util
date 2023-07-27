function Update-AdoEndpoint
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        $Organization,
        $Project,
        $EndPointId,
        $EndPoint,
        [switch]$AsJson, $ApiVersion = '7.0'
    )

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/serviceendpoint/endpoints/$($EndPointId)?api-version=$($ApiVersion)"

    if ($AsJson.IsPresent)
    {
        $body = $EndPoint
    }
    else
    {
        $body = $EndPoint | ConvertTo-Json -Depth 10 -Compress
    }

    $result = Invoke-RestMethod -Method Put -Uri $url -Body $body -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60
    
    return $result
}