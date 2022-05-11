function Get-AdoBuilds
{ 
    param(
        [ValidateNotNullOrEmpty()][alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [ValidateNotNull()]$DefinitionId,
        $StatusFilter,
        $ApiVersion = '6.0'
    )

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/build/builds?definitions=$($DefinitionId)&statusFilter=$StatusFilter&api-version=$ApiVersion"
    $builds = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return , $builds.value
}