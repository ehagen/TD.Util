function Get-AdoBuildDefinitions
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [switch]$Expand,
        $ApiVersion = '7.0'
    )

    $extraValues = $null
    if ($Expand.IsPresent)
    {
        $extraValues = 'includeAllProperties=true&includeLatestBuilds=true&'
    }
    $url = "$(Get-AdoUri $AdoUri $project $Organization)/_apis/build/definitions?$($extraValues)api-version=$ApiVersion"
    $defs = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return , $defs.Value
}
