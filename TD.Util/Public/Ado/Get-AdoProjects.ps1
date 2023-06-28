function Get-AdoProjects
{
    param(
        [ValidateNotNullOrEmpty()][alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        $Project,
        $ApiVersion = '7.0'
    )

    $url = "$(Get-AdoUri $AdoUri '' $Organization)/_apis/projects/$($Project)?api-version=$ApiVersion"
    $projects = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    if ($Project)
    {
        return , $projects
    }
    else
    {
        return , $projects.Value
    }
}