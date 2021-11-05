function Test-BuildDefinitionExists($BuildDefinitions, $BuildDefinitionName)
{
    foreach ($def in $BuildDefinitions)
    {
        if ($def.name -eq $BuildDefinitionName)
        {
            return $true
        }
    }
    return $false
}