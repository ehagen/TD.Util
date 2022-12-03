<#
.SYNOPSIS
Write script header to console host

.DESCRIPTION
Write script header to console host, useful for logging and debugging your PowerShell scripts

.PARAMETER Title
Script title

.PARAMETER Invocation
Invocation to use like $PSCommandPath

.PARAMETER ExtraParams
Extra parameters you want to write to console

.PARAMETER ShowHost
Show also console details

.EXAMPLE
Write-ScriptHeader -Title 'My Script' -Invocation $PSCommandPath -ExtraParams @{MyVar='hello'} -ShowHost

.REMARKS
$PSCommandPath contains information about the invoker or calling script, not the current script

#>
function Write-Header($Title, $Invocation, $ExtraParams, [switch]$ShowHost)
{
    $header = ''
    if ($Invocation)
    {
        if ($Invocation -is [System.Management.Automation.InvocationInfo])
        {
            $header = $Invocation.MyCommand.Name
        }
        else
        {
            $header = Split-Path $Invocation -Leaf -ErrorAction Ignore
        }
    }
    Write-Host ''.PadRight(78, '-');
    Write-Host "$Title $header"
    Write-Host ''.PadRight(78, '-');
    if ($Invocation)
    {
        Write-Host 'Parameters'
        Write-Params $Invocation
    }
    if ($ExtraParams)
    {
        if ($ExtraParams.Count -gt 0)
        {
            if ($Invocation) { Write-Host '' }
            Write-Host 'More Parameters'
            foreach ($k in $ExtraParams.GetEnumerator())
            {
                $n = $k.Name
                Write-Host "$($n.PadLeft(20)): $($k.value)"
            }
        }
    }
    if ($ShowHost.IsPresent)
    {
        Write-Host ''
        Write-HostDetails
    }
    if ($Invocation -or $ExtraParams -or $ShowHost.IsPresent)
    {
        Write-Host ''.PadRight(78, '-');
    }
}