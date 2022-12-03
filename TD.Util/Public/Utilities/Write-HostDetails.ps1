function Write-HostDetails
{
    Write-Host 'Host details'
    Write-Host "            Time: $(Get-Date -Format s)"
    Write-Host "        Computer: $([Environment]::MachineName)/$(hostname)"
    Write-Host "          WhoAmI: $([Environment]::UserName)"
    Write-Host "      Powershell: $($PSVersionTable.PsVersion)"
    Write-Host "              OS: $([Environment]::OSVersion.VersionString)"
    Write-Host "         Culture: $(Get-Culture)"
    Write-Host "  Current Folder: $(Get-Location)"
}