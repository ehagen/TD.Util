function Add-AdoVariableGroup
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $Vars, $Type, $Name, $Description, $ApiVersion = '5.1-preview.1')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/distributedtask/variablegroups?api-version=$($ApiVersion)"
    $body = @{
        variables   = $Vars
        type        = $Type
        name        = $Name
        description = $Description
    } | ConvertTo-Json -Depth 10 -Compress

    $result = Invoke-RestMethod -Method Post -Uri $url -Body $body -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60
    return $result.id
}