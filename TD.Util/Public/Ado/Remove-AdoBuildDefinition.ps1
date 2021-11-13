function Remove-AdoBuildDefinition
{
    [CmdletBinding()]
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $ApiVersion = '6.0', $Organization, $Project, $BuildDefinitionId)

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/build/definitions/$($BuildDefinitionId)?api-version=$ApiVersion"
    Invoke-RestMethod -Method Delete -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
}