function Get-AdoPool
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $PoolId, $ApiVersion = '7.0')

    $url = "$(Get-AdoUri -Uri $AdoUri -Organization $Organization)/_apis/distributedtask/pools/$($PoolId)?api-version=$ApiVersion"
    $p = Invoke-RestMethod -Method Get -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60
    return $p
}