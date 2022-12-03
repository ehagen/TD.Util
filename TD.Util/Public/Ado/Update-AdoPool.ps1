function Update-AdoPool
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $PoolId, $Body, $ApiVersion = '7.0')

    $url = "$(Get-AdoUri -Uri $AdoUri -Organization $Organization)/_apis/distributedtask/pools/$($PoolId)?api-version=$($ApiVersion)"

    if ($null -eq $Body)
    {
        throw "No details (Body) information supplied in Update-AdoPool, see https://learn.microsoft.com/en-us/rest/api/azure/devops/distributedtask/pools/update?view=azure-devops-rest-7.0 for more details"
    }

    if (($Body -is [HashTable]) -or ($Body -is [PSCustomObject]))
    {
        $jsonBody = $Body | ConvertTo-Json -Depth 5
    }
    else
    {
        $jsonBody = $Body
    }

    $result = Invoke-RestMethod -Method Patch -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60 -Body $jsonBody
    return $result.Value
}
