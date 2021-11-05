function Remove-AdoProject
{
    [CmdletBinding()]
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $ApiVersion = '6.0', $Organization, $ProjectId)

    try
    {
        $prj = $null
        $url = "$(Get-AdoUri $AdoUri '' $Organization)/_apis/projects/$($ProjectId)?api-version=$ApiVersion"
        $prj = Invoke-RestMethod -Method Delete -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
    }
    catch
    {
        if ($ErrorActionPreference -ne 'Ignore')
        {
            Throw
        }
    }
    return $prj
}