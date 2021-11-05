function Test-VariableGroupExists($VariableGroups, $VariableGroupName)
{
    foreach ($grp in $VariableGroups)
    {
        if ($grp.name -eq $VariableGroupName)
        {
            return $true
        }
    }
    return $false
}