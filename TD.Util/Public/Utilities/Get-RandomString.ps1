function Get-RandomString($Length = 20)
{
    $chars = 65..90 + 97..122
    $chars += 48..57
    $s = $null
    Get-Random -Count $Length -Input ($chars) | ForEach-Object { $s += [char]$_ }
    return $s.ToString()
}