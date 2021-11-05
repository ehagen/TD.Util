function Add-AdoEndpoint
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $EndPoint, [switch]$AsJson, $ApiVersion = '6.0-preview.4')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/serviceendpoint/endpoints?api-version=$($ApiVersion)"

    if ($AsJson.IsPresent)
    {
        $body = $EndPoint
    }
    else
    {
        $body = $EndPoint | ConvertTo-Json -Depth 10 -Compress
    }

    $result = Invoke-RestMethod -Method Post -Uri $url -Body $body -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60
    
    return $result
}