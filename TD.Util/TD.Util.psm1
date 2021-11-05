[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidGlobalVars", "")]
param(
    [parameter(Mandatory = $false)][HashTable]$ImportVars
)

$quiet = $false
if ($ImportVars -and $ImportVars.ContainsKey('Quiet'))
{
    $quiet = $ImportVars.Quiet
}
if (!($quiet))
{
    $tdUtilModule = 'TD.Util'
    $manifest = Test-ModuleManifest -Path (Join-Path (Split-Path $MyInvocation.MyCommand.Path) "$tdUtilModule.psd1") -WarningAction SilentlyContinue
    Write-Host "$tdUtilModule Version $($manifest.Version.ToString()) by $($manifest.Author)"
    Write-Host "Proudly created in Schiedam (NLD), $($manifest.Copyright)";
}

