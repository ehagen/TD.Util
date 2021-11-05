function Get-AdoAllRepositories
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Filter = { $_ }, $ApiVersion = '5.0')

    $repositories = @()
    $projects = Get-AdoProjects -AdoUri $AdoUri -AdoAuthToken $AdoAuthToken -Organization $Organization -ApiVersion $ApiVersion
    foreach ($project in $projects)
    {
        $projectRepositories = Get-AdoRepositories -AdoUri $AdoUri -AdoAuthToken $AdoAuthToken -Organization $Organization -Project $project.name
        $projectRepositories = $projectRepositories | Where-Object $Filter
        foreach ($r in $projectRepositories)
        {
            $defBranch = ''
            if (Test-PSProperty $r 'defaultBranch')
            {
                $defBranch = $r.defaultBranch
            }
            $repositories += [PSCustomObject]@{
                Project       = $project.name
                Name          = $r.name
                Id            = $r.id
                DefaultBranch = $defBranch
                RemoteUrl     = $r.RemoteUrl
                Url           = $r.url
                WebUrl        = $r.webUrl
                Object        = $r
            }
        }
    }
    return , ($repositories | Sort-Object -Property Project, Name)
}