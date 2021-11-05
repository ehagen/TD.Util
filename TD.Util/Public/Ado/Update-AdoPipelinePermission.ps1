function Update-AdoPipelinePermission
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $ResourceType, $ResourceId, $PipelineId, $ApiVersion = '6.1-preview.1')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/pipelines/pipelinePermissions/$($ResourceType)/$($ResourceId)?api-version=$($ApiVersion)"
    $permission = @{
        pipelines = @(
            @{
                id         = $PipelineId
                authorized = $true
            }
        )
    }
    $body = $permission | ConvertTo-Json -Depth 10 -Compress
    $result = Invoke-RestMethod -Method Patch -Uri $url -Body $body -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60

    return $result
}