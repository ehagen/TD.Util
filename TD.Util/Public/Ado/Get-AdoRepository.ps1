function Get-AdoRepository
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $Repo, $ApiVersion = '5.0')

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/git/repositories/$($Repo)?includeLinks=true&includeAllUrls=true&includeHidden=true&api-version=$ApiVersion"
    $repo = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return $repo
}