function Merge-Objects($Objects)
{
    $props = @{}
    foreach ($o in $Objects)
    {
        foreach ($property in $o.PSObject.Properties)
        {
            if ($props.ContainsKey($property.Name))
            {
                # ignore duplicates
            }
            else
            {
                [void]$props.Add($property.Name, $property.value)
            }
        }
    }
    return [PSCustomObject]$props
}