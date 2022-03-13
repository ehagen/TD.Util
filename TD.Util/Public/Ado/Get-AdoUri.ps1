function Get-AdoUri
{ 
    param($Uri, $Project, $Organization)

    if ($Uri) 
    { 
        $lUri = [System.Uri]$Uri 
    } 
    else 
    { 
        if ($env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI) 
        { 
            $lUri = [System.Uri]$env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI 
        } 
        else 

        { 
            if ($Organization) 
            { 
                $lUri = [System.Uri]"https://dev.azure.com/$Organization" 
            } 
            else
            { 
                Throw "Unable to create Azure DevOps organization url, no Organization defined"
            } 
        } 
    } 

    if ($Project) 
    { 
        $uriBuilder = [System.UriBuilder]$lUri 
        if ($uriBuilder.Path.EndsWith('/')) { $s = '' } else { $s = '/' } 
        $uriBuilder.Path += "$s$Project" 
        $lUri = $uriBuilder.Uri 
    } 

    return $lUri.ToString() 
} 