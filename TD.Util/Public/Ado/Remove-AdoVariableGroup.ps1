function Remove-AdoVariableGroup
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, [alias('Id')]$aId, $ApiVersion = '5.1-preview.1')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/distributedtask/variablegroups/$($aId)?api-version=$($ApiVersion)"
    Invoke-RestMethod -Method Delete -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60
}