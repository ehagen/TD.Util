function Get-AdoBuilds
{ 
    param(
        [ValidateNotNullOrEmpty()][alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [ValidateNotNull()]$DefinitionId,
        $ApiVersion = '6.0'
    )

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/build/builds?definitions=$($DefinitionId)&api-version=$ApiVersion"
    $builds = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return , $builds.value
}