function Save-ObjectToJsonFile($Path, $Object, $Depth = 10)
{
    function Set-Props($Object)
    {
        foreach ($prop in $Object.PsObject.Properties)
        {
            if ($prop.Value -is [SecureString])
            {
                $prop.Value = [SecureStringStorage]$prop.Value
            }
        }
    }

    # fix SecureString references
    Set-Props $object

    $Object | ConvertTo-Json -Depth $Depth | Set-Content -Path $Path -Force
}