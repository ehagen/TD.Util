function Copy-ObjectPropertyValues($FromObject, $ToObject, [switch]$Deep)
{
    if ($Deep.IsPresent)
    {
        throw "Deep copy properties not supported in Copy-ObjectPropertyValues"
    }

    foreach ($prop in $FromObject.PSObject.Properties)
    {
        if (Test-PSProperty $ToObject $prop.Name)
        {
            $ToObject."$($prop.Name)" = $prop.Value
        }
    }    
    return $ToObject
}