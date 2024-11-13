function Get-AdoPipelinePendingApprovals
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        $BuildDefinitionId,
        $ApiVersion = '7.1-preview.1'
    )

    $splat = @{
        Token = $AdoAuthToken
        Organization = $Organization
        Project = $Project
    }

    if ($BuildDefinitionId)
    {
        $bd = @{
            DefinitionId = $BuildDefinitionId
        }
    }
    else
    {
        $bd = @{}
    }

    $builds = Get-AdoBuilds @splat -StatusFilter 'inProgress,notStarted' @bd
    $approvals = @()
    foreach ($b in $builds) {
        $bt = Get-AdoBuildTimeline @splat -Id $b.id -TimelineId $b.orchestrationPlan.planId
        $buildApprovals = $bt.records | Where-Object { ($_.type -eq 'Checkpoint.Approval' -and $_.state -eq 'inProgress') }
        foreach ($buildApproval in $buildApprovals)
        {
            $apr = Get-AdoPipelineApprovals @splat -Ids $buildApproval.id
            if ($apr -and ($null -ne $apr[0]))
            {
                $checkpoint = $bt.records | Where-Object { $_.id -eq $buildApproval.parentId }
                $stage = $bt.records | Where-Object { $_.id -eq $checkpoint.parentId }
                $approvals += @{
                    BuildDefinition = $b.Definition.id
                    BuildName = $b.Definition.name
                    BuildId = $b.Id
                    BuildUrl = $b._links.web.href
                    StageId = $stage.id
                    Stage = $stage.identifier
                    StageName = $stage.name
                    ApprovalId = $apr[0].id
                    Approval = $apr[0]
                }
            }
        }
    }
    return $approvals
}
