function Remove-AdoRepository
{
    [CmdletBinding()]
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $ApiVersion = '6.0', $Organization, $Project, $RepoId)

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/git/repositories/$($RepoId)?api-version=$ApiVersion"
    Invoke-RestMethod -Method Delete -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
}