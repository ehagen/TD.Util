function Add-AdoRepository
{
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $Repo, $ApiVersion = '6.0')

    $url = "$(Get-AdoUri -Uri $AdoUri -Project $Project -Organization $Organization)/_apis/git/repositories?api-version=$($ApiVersion)"

    $request = @{
        name = $Repo
    }

    $body = $request | ConvertTo-Json -Depth 10 -Compress

    $result = Invoke-RestMethod -Method Post -Uri $url -Body $body -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -ContentType 'application/json' -TimeoutSec 60
    return $result
}