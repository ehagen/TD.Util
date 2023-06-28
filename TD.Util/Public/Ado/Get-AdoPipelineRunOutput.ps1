function Get-AdoPipelineRunOutput
{
    param(
        [ValidateNotNullOrEmpty()][alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [ValidateNotNull()]$Id,
        [ValidateNotNull()]$RunId,
        [switch]$All,
        $ApiVersion = '7.0'
    )

    $params = @{
        Organization = $Organization
        Project      = $Project
        ApiVersion   = $ApiVersion
    }
    if ($AdoUri) { [void]$params.Add('AdoUri', $AdoUri) }
    if ($AdoAuthToken) { [void]$params.Add('AdoAuthToken', $AdoAuthToken) }
    $output = $null
    $logs = Get-AdoPipelineRunLogs @params -Id $Id -RunId $RunId
    foreach ($log in $logs)
    {        
        $l = Get-AdoPipelineRunLog @params -Id $Id -RunId $RunId -LogId $log.id
        $contents = Invoke-RestMethod -Uri $l.signedContent.url
        $output += $contents

        if (!($All.IsPresent))
        {
            break
        }
    }
    return $output
}