function Get-AdoVariableGroup
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $Name, $ApiVersion = '5.1-preview.1')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/distributedtask/variablegroups/?groupName=$($Name)&actionFilter=none&api-version=$($ApiVersion)"
    $result = Invoke-RestMethod -Method Get -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60
    return $result.Value
}