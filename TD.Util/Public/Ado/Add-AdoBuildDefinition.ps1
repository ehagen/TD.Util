function Add-AdoBuildDefinition
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $Definition, [switch]$AsJson, $ApiVersion = '6.0')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/build/definitions?api-version=$($ApiVersion)"

    if ($AsJson.IsPresent)
    {
        $body = $Definition
    }
    else
    {
        $body = $Definition | ConvertTo-Json -Depth 10 -Compress
    }

    $result = Invoke-RestMethod -Method Post -Uri $url -Body $body -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60
    return $result
}