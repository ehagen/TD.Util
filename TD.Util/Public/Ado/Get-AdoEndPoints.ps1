function Get-AdoEndPoints
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $ApiVersion = '6.0-preview.4', $Type, [switch]$Detailed)

    $detailOption = ''
    if ($detailed.IsPresent)
    {
        $detailOption = 'includeDetails=true&'
    }
    $typeOption = ''
    if ($Type)
    {
        $typeOption = "type=$type&"
    }
    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/serviceendpoint/endpoints?$($typeOption)$($detailOption)api-version=$ApiVersion"
    $endpoints = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return , $endpoints.Value
}