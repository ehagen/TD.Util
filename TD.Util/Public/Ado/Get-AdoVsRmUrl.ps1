function Get-AdoVsRmUrl($Url)
{ 
    return $Url.Replace('dev.azure.com', 'vsrm.dev.azure.com') 
} 