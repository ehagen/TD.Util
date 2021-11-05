function Invoke-AdoCreateRelease
{ 
    param([alias('u', 'Uri')][string]$AdoUri, [alias('t', 'Token', 'Pat')][string]$AdoAuthToken, $Organization, $Project, $DefinitionId, $BuildId, $BuildAlias, $Reason = 'UserCreated', $ApiVersion = '5.0') 

    $body = @{ "definitionId" = "$($DefinitionId)"; "reason" = "$Reason" } 
    $body.Add("artifacts", @()) 

    $artifact = @{ 
        "alias"             = "$($BuildAlias)" 
        "instanceReference" = @{ 
            "id"   = "$($BuildId)" 
            "name" = $null 
        } 
    } 

    $body.artifacts += $artifact 
    $jsonBody = $body | ConvertTo-Json -Depth 5 
    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/release/releases?api-version=$ApiVersion"
    $url = Get-AdoVsRmUrl $url 
    $release = Get-AdoApiResult -AdoUri $url -AdoAuthToken $AdoAuthToken -Method Post -Body $jsonBody -ContentType 'application/json' 

    return $release 
} 