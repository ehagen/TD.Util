<#
.SYNOPSIS
Write parameter names & values to console host

.DESCRIPTION
Write or echo's parameter names and values to console host, useful for logging and debugging your PowerShell scripts

.PARAMETER Invocation
Invocation to use like $PSCommandPath or $MyInvocation

.EXAMPLE
Write-Params -Invocation $PSCommandPath

.REMARKS
$PSCommandPath contains information about the invoker or calling script, not the current script
$MyInvocation contains information about current context

#>
function Write-Params($Invocation)
{
    if ($Invocation)
    {
        $ivo = $Invocation
    }
    else
    {
        try
        {
            $ivo = $PSCmdlet.MyInvocation
        }
        catch
        {
            return;
        }
    }

    try
    {
        $i = Get-Command -Name $ivo -ErrorAction SilentlyContinue
        if (!$i) 
        {
            $i = Get-Command -Name $ivo.InvocationName -ErrorAction SilentlyContinue 
        }
        if ($i)
        {
            $parameterList = $i.ParameterSets.Parameters
            if (!$parameterList) 
            {
                return; 
            }
        }
        else
        {
            return
        }
    }
    catch
    {
        Write-Host 'Unable to write parameters'
        return;
    }

    # detect unwrap
    if ($parameterList -is [System.Management.Automation.CommandParameterInfo])
    {
        $list = @($parameterList)
    }
    else
    {
        $list = $parameterList
    }
    foreach ($key in $list.GetEnumerator())
    {
        $var = Get-Variable -Name $key.Name -ErrorAction SilentlyContinue;
        if ($var)
        {
            $n = $var.name
            foreach ($alias in $key.Aliases)
            {
                if ($var.name -like "*$alias*")
                {
                    $n = $alias
                }
            }
            if ($n -in 'pw', 'pwd', 'password', 'secret')
            {
                Write-Host "$($n.PadLeft(20)): *************"
            }
            else
            {
                if ($var.value -and $var.value -is [HashTable])
                {
                    Write-Host "$($n.PadLeft(20)) "
                    foreach ($item in $var.Value.Keys)
                    {
                        Write-Host "$($item.PadLeft(24)): $($var.value[$item])"
                    }
                }
                else
                {
                    Write-Host "$($n.PadLeft(20)): $($var.value)"
                }
            }
        }
    }
}