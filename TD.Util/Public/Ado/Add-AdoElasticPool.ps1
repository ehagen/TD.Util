function Add-AdoElasticPool
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Name,
        [ValidateNotNullOrEmpty()]$AuthorizeAllPipelines,
        [ValidateNotNullOrEmpty()]$AutoProvisionProjectPools,
        $ProjectId,
        [ValidateNotNullOrEmpty()]$Body,
        $ApiVersion = '7.0'
    )

    $extraParams = ''
    if ($ProjectId)
    {
        $extraParams = "&projectId=$($ProjectId)"
    }
    $url = "$(Get-AdoUri -Uri $AdoUri -Organization $Organization)/_apis/distributedtask/elasticpools?poolName=$($Name)&authorizeAllPipelines=$($AuthorizeAllPipelines)&autoProvisionProjectPools=$($AutoProvisionProjectPools)$($extraParams)&api-version=$($ApiVersion)"

    if (($Body -is [HashTable]) -or ($Body -is [PSCustomObject]))
    {
        $jsonBody = $Body | ConvertTo-Json -Depth 5
    }
    else
    {
        $jsonBody = $Body
    }

    $result = Invoke-RestMethod -Method Post -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60 -Body $jsonBody
    return $result
}