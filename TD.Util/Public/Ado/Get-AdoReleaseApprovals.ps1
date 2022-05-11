function Get-AdoReleaseApprovals
{ 
    param(
        [ValidateNotNullOrEmpty()][alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [ValidateNotNull()]$StatusFilter = 'pending',
        $ApiVersion = '6.0'
    ) 

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/release/approvals?api-version=$ApiVersion"
    $url = Get-AdoVsRmUrl $url
    $approvals = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60 
    return , $approvals.value
} 