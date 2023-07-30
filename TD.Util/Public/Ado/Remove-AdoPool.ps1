function Remove-AdoPool
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        $Organization,
        $PoolId,
        $ApiVersion = '7.0'
    )

    $url = "$(Get-AdoUri -Uri $AdoUri -Organization $Organization)/_apis/distributedtask/pools/$($PoolId)?api-version=$($ApiVersion)"
    Invoke-RestMethod -Method Delete -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
}