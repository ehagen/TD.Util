function Get-AdoPipeline
{ 
    param(
        [ValidateNotNullOrEmpty()][alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        [ValidateNotNullOrEmpty()]$Project,
        [ValidateNotNull()]$Id,
        $ApiVersion = '7.0'
    ) 

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/pipelines/$($Id)?api-version=$ApiVersion" 
    $pipeline = Invoke-RestMethod -Uri $url -Headers @{Authorization = "$(New-AdoAuthenticationToken $AdoAuthToken)" } -TimeoutSec 60 
    return $pipeline 
} 