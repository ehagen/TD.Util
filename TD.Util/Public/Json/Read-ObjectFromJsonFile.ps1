function Read-ObjectFromJsonFile($Path, $Depth = 10)
{
    if (Test-Path $Path)
    {
        $object = Get-Content -Path $Path | ConvertFrom-Json -Depth $Depth
    }
    else
    {
        $object = [PSCustomObject]@{}
    }

    function Set-Props($Object)
    {
        foreach ($prop in $Object.PsObject.Properties)
        {
            if ($prop.Value -is [HashTable])
            {
                if ($prop.Value.ContainsKey('TypeName') -and ($prop.Value.TypeName -eq 'SecureStringStorage') )
                {
                    $prop.Value = [SecureStringStorage]$prop.Value
                }
            }
            elseif ($prop.Value -is [PSCustomObject])
            {
                if ($prop.Value.TypeName -and ($prop.Value.TypeName -eq 'SecureStringStorage') )
                {
                    $prop.Value = [SecureStringStorage]$prop.Value
                }
                else
                {
                    Set-Props $prop.Value
                }
            }
        }
    }

    # fix SecureString references
    Set-Props $object

    return $object
}