function Get-AdoPipelineApprovals
{ 
    param(
        [ValidateNotNullOrEmpty()][alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        $Ids,
        $ApiVersion = '7.1-preview.1'
    ) 

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/pipelines/approvals?approvalIds=$Ids&api-version=$ApiVersion"
    $approvals = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60 
    return , $approvals.value
} 