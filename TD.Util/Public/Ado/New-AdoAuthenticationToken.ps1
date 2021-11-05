function New-AdoAuthenticationToken([alias('p', 'Pat')][string] $Token) 
{ 
    $accessToken = ""; 
    if ($Token) 
    { 
        $user = "" 
        $encodedToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $User, $Token))) 
        $accessToken = "Basic $encodedToken" 
    } 
    elseif ($env:SYSTEM_ACCESSTOKEN) 
    { 
        $accessToken = "Bearer $($env:SYSTEM_ACCESSTOKEN)" 
    } 
    else 
    { 
        Throw "No AccessToken or Personal Access Token (PAT) supplied" 
    } 
    return $accessToken; 
} 