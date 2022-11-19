function Get-AdoEnvironments
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $ApiVersion = '7.0')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/distributedtask/environments?api-version=$($ApiVersion)"
    $result = Invoke-RestMethod -Method Get -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60
    return $result.Value
} 