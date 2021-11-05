function Get-AdoQueue
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $ApiVersion = '6.0-preview.1', $Organization, $Project, $Queue)

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/distributedtask/queues?queueName=$($Queue)&api-version=$ApiVersion"
    $q = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return $q
}