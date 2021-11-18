function ConvertTo-TitleCase([alias('t')]$Text, [alias('c')][string] $Culture = 'en-US')
{
    $c = New-Object System.Globalization.CultureInfo($Culture)
    return ($c.TextInfo.ToTitleCase($Text))
}
