function Convert-ObjectToHashTable([object[]]$Object)
{
    foreach ($o in $Object)
    {
        $output = @{}
        $o | Get-Member -MemberType *Property | ForEach-Object {
            $value = $o.($_.name)
            if ($value -is [PSCustomObject])
            {
                $value = Convert-ObjectToHashTable -Object $value
            }
            $output.($_.name) = $value
        }
        $output
    }
}