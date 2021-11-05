function Grant-AdoPipelineResourceAccess
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $Access, [switch]$AsJson, $ApiVersion = '6.0')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/pipelines/pipelinePermissions?api-version=$($ApiVersion)"

    if ($AsJson.IsPresent)
    {
        $body = $Access
    }
    else
    {
        $body = $Access | ConvertTo-Json -Depth 10 -Compress
    }

    $result = Invoke-RestMethod -Method Patch -Uri $url -Body $body -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60
    return $result
}