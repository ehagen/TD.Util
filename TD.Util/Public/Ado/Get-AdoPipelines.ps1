function Get-AdoPipelines
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        $StatusFilter,
        $ApiVersion = '7.0'
    )

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/pipelines?api-version=$ApiVersion"
    $pipelines = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return , $pipelines.value
}
