<#
.SYNOPSIS
Get an Unique Id, default it's a guid

.DESCRIPTION
Get an Unique Id, default it's a guid. Decrease size when you need shorter unique id but sacrifice on id accuracy / collision possibility

.PARAMETER Size
Size of Id, default 32 characters

#>function Get-UniqueId([ValidateRange(6, 32)][Int]$Size = 32)
{
    return ([Guid]::NewGuid().ToString('n')).SubString(0, $Size)
}