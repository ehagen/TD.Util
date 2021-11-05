function Get-AdoApiResult([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Method = 'Get', [alias('Body')]$aBody, $ContentType) 
{ 
    $params = @{} 
    if ($aBody) { $params.Add('Body', $aBody) } 
    if ($ContentType) { $params.Add('ContentType', $ContentType) } 
    return Invoke-RestMethod -Uri $AdoUri -Method $Method -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60 @params 
} 