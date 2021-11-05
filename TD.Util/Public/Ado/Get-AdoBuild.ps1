function Get-AdoBuild
{ 
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $Id, $ApiVersion = '5.0') 

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/build/builds/$($Id)?api-version=$ApiVersion" 
    $build = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60 
    return $build 
} 