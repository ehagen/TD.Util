function Get-AdoRepositoryPolicy
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $RepoId, $RefName, $ApiVersion = '5.0')

    if ($RepoId)
    {
        $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/git/policy/configurations?repositoryId=$($RepoId)&refName=$($RefName)&api-version=$ApiVersion"
    }
    else
    {
        $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/git/policy/configurations?api-version=$ApiVersion"
    }
    $policies = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    return ,$policies.Value
}