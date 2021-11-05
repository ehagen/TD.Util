function Add-AdoPullRequest
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $RepoId, $SourceRefName, $TargetRefName = 'master', $Description = 'PR Created via REST API', $User = 'monitor', $ApiVersion = '6.0')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/git/repositories/$RepoId/pullRequests?api-version=$($ApiVersion)"

    $ref = "refs/heads/"
    $sourceBranch = "$Ref$SourceRefName"
    $targetBranch = "$Ref$TargetRefName"
    $request = @{
        sourceRefName     = $sourceBranch
        targetRefName     = $targetBranch
        title             = "Merge $SourceRefName to $TargetRefName by $User"
        description       = $Description
        autoCompleteSetBy = @{
            id          = $User
            displayName = $User
        }
        createdBy         = @{
            id          = $User
            displayName = $User
        }
    }

    $body = $request | ConvertTo-Json -Depth 10 -Compress

    $result = Invoke-RestMethod -Method Post -Uri $url -Body $body -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60
    return $result.pullRequestId
}