function Get-AdoProject
{
    [CmdletBinding()]
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        $ApiVersion = '7.0'
    )

    try
    {
        $prj = $null
        $url = "$(Get-AdoUri $AdoUri '' $Organization)/_apis/projects/$($Project)?includeCapabilities=true&includeHistory=true&api-version=$ApiVersion"
        $prj = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60
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
