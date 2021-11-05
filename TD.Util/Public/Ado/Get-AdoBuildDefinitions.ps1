function Get-AdoBuildDefinitions
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $ApiVersion = '6.0')

    $url = "$(Get-AdoUri $AdoUri $project $Organization)/_apis/build/definitions?api-version=$ApiVersion"
    $defs = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return , $defs.Value
}