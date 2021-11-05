function Invoke-AdoQueueBuild
{ 
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $Id, $Branch, $Reason = 'UserCreated', $ApiVersion = '5.0')

    if ($Branch) { $lBranch = $Branch } else { $lBranch = '' }
    $body = "{`"definition`": { `"id`": $Id }, reason: `"$Reason`", priority: `"Normal`", tags: `"`", sourceBranch: `"$lBranch`"}"

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/build/builds?api-version=$ApiVersion"
    $build = Get-AdoApiResult -AdoUri $url -AdoAuthToken $AdoAuthToken -Method Post -Body $body -ContentType 'application/json'
    return $build
} 