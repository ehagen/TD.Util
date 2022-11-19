function Add-AdoEnvironment
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $Name, $Description, $ApiVersion = '7.0')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/distributedtask/environments?api-version=$($ApiVersion)"

    $body = @{ 
        name        = $Name
        description = $Description
    } 
    $jsonBody = $body | ConvertTo-Json -Depth 5 

    $result = Invoke-RestMethod -Method Post -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60 -Body $jsonBody
    return $result.Value
}