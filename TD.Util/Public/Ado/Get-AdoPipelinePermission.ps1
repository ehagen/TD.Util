function Get-AdoPipelinePermission
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $ResourceType, $ResourceId, $ApiVersion = '6.1-preview.1')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/pipelines/pipelinePermissions/$($ResourceType)/$($ResourceId)?api-version=$($ApiVersion)"
    $result = Invoke-RestMethod -Method Get -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60

    return $result
}