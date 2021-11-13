function Save-ObjectToJsonFile($Path, $Object, $Depth = 10)
{
    $Object | ConvertTo-Json -Depth $Depth | Set-Content -Path $Path -Force
}