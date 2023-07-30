function Add-AdoPool
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        $Organization,
        $Name,
        $Body,
        $ApiVersion = '7.0'
    )

    $url = "$(Get-AdoUri -Uri $AdoUri -Organization $Organization)/_apis/distributedtask/pools?api-version=$($ApiVersion)"

    if ($null -eq $Body)
    {
        $Body = @{ 
            name = $Name
        }
    } 
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