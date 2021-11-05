function Test-RepositoryExists($Repos, $RepoName)
{
    foreach ($repo in $Repos)
    {
        if ($repo.name -eq $RepoName)
        {
            return $true
        }
    }
    return $false
}