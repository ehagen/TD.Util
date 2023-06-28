function Get-AdoBuildDefinition
{
    param(
        [ValidateNotNullOrEmpty()][alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [ValidateNotNullOrEmpty()]$Id,
        $ApiVersion = '7.0'
    )

    $url = "$(Get-AdoUri $AdoUri $project $Organization)/_apis/build/definitions/$($Id)?includeAllProperties=true&includeLatestBuilds=true&api-version=$ApiVersion"
    $def = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return $def.Value
}