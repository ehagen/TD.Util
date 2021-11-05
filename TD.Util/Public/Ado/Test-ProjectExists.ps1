function Test-ProjectExists($Projects, $ProjectName)
{
    foreach ($project in $Projects)
    {
        if ($project.name -eq $ProjectName)
        {
            return $true
        }
    }
    return $false
}