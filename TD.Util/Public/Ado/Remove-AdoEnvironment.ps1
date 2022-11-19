function Remove-AdoEnvironment
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $EnvironmentId, $ApiVersion = '7.0')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/distributedtask/environments/$($EnvironmentId)?api-version=$($ApiVersion)"
    Invoke-RestMethod -Method Delete -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
}