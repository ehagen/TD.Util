function Update-AdoVariableGroup
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, [alias('Id')]$aId, $Vars, $Type, $Name, $Description, $ApiVersion = '5.1-preview.1')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/distributedtask/variablegroups/$($aId)?api-version=$($ApiVersion)"
    $vars = @{
        variables = $Vars
        name      = $Name
    }
    if ($Type) { $vars.Add('type', $Type) | Out-Null }
    if ($Description) { $vars.Add('description', $Description) | Out-Null }
    $body = $vars | ConvertTo-Json -Depth 10 -Compress
    $result = Invoke-RestMethod -Method Put -Uri $url -Body $body -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60
    return $result.id
}