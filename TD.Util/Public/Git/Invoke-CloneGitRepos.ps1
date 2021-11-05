function Invoke-CloneGitRepos($Root, $Repos, [switch]$Reset)
{
    # use repo's from Get-AdoAllRepositories
    # use git.exe for cloning
    $repos = $Repos | Sort-Object -Property Name, Project | Where-Object { $_ }
    foreach ($r in $repos)
    {
        Invoke-CloneGitRepo -Root $Root -RepoUrl $r.RemoteUrl -Reset:$Reset
    }
}