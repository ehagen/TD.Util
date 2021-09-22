$tdUtilModule = 'TD.Util'
$manifest = Test-ModuleManifest -Path (Join-Path (Split-Path $MyInvocation.MyCommand.Path) "$tdUtilModule.psd1") -WarningAction SilentlyContinue
Write-Host "$tdUtilModule Version $($manifest.Version.ToString()) by $($manifest.Author)"
Write-Host "Proudly created in Schiedam (NLD), $($manifest.Copyright)";
