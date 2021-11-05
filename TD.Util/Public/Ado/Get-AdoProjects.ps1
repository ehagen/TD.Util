function Get-AdoProjects
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $ApiVersion = '5.0', $Organization)

    $url = "$(Get-AdoUri $AdoUri '' $Organization)/_apis/projects?api-version=$ApiVersion"
    $projects = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return , $projects.Value
}