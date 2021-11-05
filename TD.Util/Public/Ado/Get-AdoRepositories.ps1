function Get-AdoRepositories
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $ApiVersion = '5.0')

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/git/repositories?includeLinks=true&includeAllUrls=true&includeHidden=true&api-version=$ApiVersion"
    $repositories = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return , $repositories.Value
}