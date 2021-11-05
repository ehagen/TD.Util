function Update-AdoPipelinePermissions
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $Resources, $ApiVersion = '6.1-preview.1')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/pipelines/pipelinePermissions?api-version=$($ApiVersion)"
    $body = $Resources | ConvertTo-Json -Depth 10 -Compress
    $result = Invoke-RestMethod -Method Patch -Uri $url -Body $body -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60

    return $result
}