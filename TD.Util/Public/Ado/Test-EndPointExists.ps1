function Test-EndPointExists($EndPoints, $EndPointName)
{
    foreach ($ep in $EndPoints)
    {
        if ($ep.name -eq $EndPointName)
        {
            return $true
        }
    }
    return $false
}