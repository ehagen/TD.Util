function Get-AdoBuilds
{ 
    param(
        [ValidateNotNullOrEmpty()][alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [ValidateNotNull()]$DefinitionId,
        $StatusFilter,
        [switch]$NoLimit,
        $ApiVersion = '6.0'
    )

    $limit = 'maxBuildsPerDefinition=50&'
    if ($NoLimit.IsPresent)
    {
        $limit = ''
    }
    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/build/builds?$($limit)queryOrder=startTimeDescending&definitions=$($DefinitionId)&statusFilter=$StatusFilter&api-version=$ApiVersion"
    $builds = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return , $builds.value
}