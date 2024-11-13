function Update-AdoPipelineApproval
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [Parameter(Mandatory)][ValidateNotNull()]$ApprovalId,
        [ValidateSet('approved', 'canceled', 'skipped', 'rejected')]$Status,
        $Comment = '',
        $ApiVersion = '6.1-preview.1'
    )

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/pipelines/approvals?api-version=$($ApiVersion)"
    $approvals = @(
        @{
            approvalId = $ApprovalId
            comment    = $Comment
            status     = $Status
        }
    )
    $body = $approvals | ConvertTo-Json -AsArray -Depth 10 -Compress
    $result = Invoke-RestMethod -Method Patch -Uri $url -Body $body -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60

    return $result
}
