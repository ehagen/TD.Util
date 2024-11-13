function Get-AdoBuildOutput
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [ValidateNotNull()]$Id,
        $ApiVersion = '6.0'
    )

    $params = @{
        Organization = $Organization
        Project      = $Project
    }
    if ($AdoUri) { [void]$params.Add('AdoUri', $AdoUri) }
    if ($AdoAuthToken) { [void]$params.Add('AdoAuthToken', $AdoAuthToken) }
    $output = $null
    $logs = Get-AdoBuildLogs @params -Id $Id
    foreach ($log in $logs)
    {
        $output += Get-AdoBuildLog @params -Id $Id -LogId $log.id
    }
    return $output
}
