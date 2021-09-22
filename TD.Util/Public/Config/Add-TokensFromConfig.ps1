<#
.SYNOPSIS
Get tokens from config repository and add them to token collection

.DESCRIPTION
Get tokens from xml config repository and add them to token collection

.PARAMETER ConfigPath
Root path of the xml config files

.PARAMETER Tokens
Hashtable to add tokens to

.PARAMETER Env
Token environment filter, filter the tokens by environent like local, develop, test etc...

.Example
$Tokens = @{}
Add-TokensFromConfig -ConfigPath "$PSScriptRoot/config" -Tokens $Tokens -Env 'local'
#>
function Add-TokensFromConfig([Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$ConfigPath, [Parameter(Mandatory = $true)]$Tokens, [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Env, $Module)
{
    function Add-Var($Nodes, $NameProp = 'name', $ValueProp = 'value', $Prefix)
    {
        foreach ($node in $Nodes)
        {
            $name = ''
            $value = $null

            if (Test-PSProperty $node $NameProp)
            {
                $name = $node."$NameProp"
            }

            if (Test-PSProperty $node $ValueProp)
            {
                $value = Get-PSPropertyValue $node "$ValueProp"
                if ($value -and $value.StartsWith('$'))
                {
                    $value = Invoke-Expression "Write-Output `"$($value)`""
                }    
            }

            $pre = $Prefix

            if ($node.LocalName -eq 'node')
            {
                if ($node.ParentNode.ParentNode.name -ne $Env)
                {
                    continue
                }
            }
            elseif ($node.LocalName -eq 'system-user')
            {
                if ($node.ParentNode.LocalName -eq 'application')
                {
                    $name = ''
                    $pre = "$Prefix$($node.ParentNode.name)"
                }
            }

            if ($pre)
            {
                $kn = "$pre$name"
                Write-Host "Adding variable $kn : $value to Token Store"
                if (!$Tokens.ContainsKey($kn))
                {
                    $Tokens.Add($kn, $value)
                }
            }
            else
            {
                if (!$Tokens.ContainsKey($name))
                {
                    Write-Host "Adding variable $name : $value to Token Store"
                    $Tokens.Add($name, $value)
                }
            }
        }
    }

    function Add-Modules($Nodes, $Module)
    {
        foreach ($node in $Nodes)
        {
            if ($Module -and ($node.name -ne $Module))
            {
                continue
            }

            Write-Host "Adding module $($node.name) to Token Store"
            $Tokens.Add("module-$($node.name)", $node.name)
            $Tokens.Add("module-$($node.name)-role", (Get-PSPropertyValue $node role))
            $Tokens.Add("module-$($node.name)-depends", (Get-PSPropertyValue $node depends))
            $Tokens.Add("module-$($node.name)-folder", (Get-PSPropertyValue $node folder))
            $nodeApps = $node.SelectNodes(".//application")
            foreach ($nodeApp in $NodeApps)
            {
                Write-Host "Adding module $($node.name) application $($nodeApp.name) to Token Store"
                $Tokens.Add("module-$($node.name)-application-$($nodeApp.name)", $nodeApp.name)
                $Tokens.Add("module-$($node.name)-application-$($nodeApp.name)-type", (Get-PSPropertyValue $nodeApp type))
                $Tokens.Add("module-$($node.name)-application-$($nodeApp.name)-role", (Get-PSPropertyValue $nodeApp role))
                $Tokens.Add("module-$($node.name)-application-$($nodeApp.name)-service", (Get-PSPropertyValue $nodeApp service))
                $Tokens.Add("module-$($node.name)-application-$($nodeApp.name)-exe", (Get-PSPropertyValue $nodeApp exe))
                $Tokens.Add("module-$($node.name)-application-$($nodeApp.name)-dotnet-version", (Get-PSPropertyValue $nodeApp 'dotnet-version'))
                if (!$Tokens.ContainsKey("application-$($nodeApp.name)"))
                {
                    $Tokens.Add("application-$($nodeApp.name)", $($node.name))
                }
                else
                {
                    Write-Warning "Duplicate application name '$("application-$($nodeApp.name)")' found"
                }
            }
        }
    }

    $modules = @()
    Get-ChildItem "$ConfigPath\*.xml" -Recurse | ForEach-Object {
        $doc = [xml] (Get-Content $_.Fullname)
        $nodes = $doc.SelectNodes("//variable[@environment='$Env' or not(@environment)]")
        Add-Var $nodes
        $nodes = $doc.SelectNodes("//node")
        if ($nodes.Count -gt 0)
        {
            Add-Var $nodes -NameProp 'role' -ValueProp 'name' -Prefix 'node-'
        }
        $nodes = $doc.SelectNodes("//service[@environment='$Env' or not(@environment)]")
        if ($nodes.Count -gt 0)
        {
            Add-Var $nodes -Prefix 'service-'
            Add-Var $nodes -Prefix 'service-cert-hash-' -ValueProp 'cert-hash'
            Add-Var $nodes -Prefix 'service-type-' -ValueProp 'type'
            Add-Var $nodes -Prefix 'service-healthcheck-' -ValueProp 'healthcheck'
            Add-Var $nodes -Prefix 'service-healthcheck-type-' -ValueProp 'healthcheck-type'
            Add-Var $nodes -Prefix 'service-healthcheck-interval-' -ValueProp 'healthcheck-interval'
        }
        $nodes = $doc.SelectNodes("//system-user[@environment='$Env' or not(@environment)]")
        if ($nodes.Count -gt 0)
        {
            Add-Var $nodes -NameProp 'system-user' -ValueProp 'name' -Prefix 'system-user-'
        }
        $nodes = $doc.SelectNodes("//module")
        if ($nodes.Count -gt 0)
        {
            Add-Modules -Nodes $nodes -Module $Module
            $nodes | ForEach-Object { $modules += $_.name }
        }
        $envNode = $doc.SelectSingleNode("//environment[@name='$Env']")
        if ($envNode)
        {
            $Tokens.Add('env-name', $envNode.'name')
            $Tokens.Add('env-group', (Get-PSPropertyValue $envNode 'group'))
            $Tokens.Add('env-name-short', (Get-PSPropertyValue $envNode 'name-short'))
            $Tokens.Add('env-name-suffix', (Get-PSPropertyValue $envNode 'name-suffix'))
            $Tokens.Add('env-type', (Get-PSPropertyValue $envNode 'type'))
            $Tokens.Add('env-active', (Get-PSPropertyValue $envNode 'active'))
            $Tokens.Add('env-domain', (Get-PSPropertyValue $envNode 'domain'))
            $Tokens.Add('env-domain-full', (Get-PSPropertyValue $envNode 'domain-full'))
            $Tokens.Add('env-domain-description', (Get-PSPropertyValue $envNode 'description'))
            $Tokens.Add('env-domain-owner', (Get-PSPropertyValue $envNode 'owner'))
            $Tokens.Add('env-domain-notes', (Get-PSPropertyValue $envNode 'notes'))
            $Tokens.Add('env-ps-remote-user', (Get-PSPropertyValue $envNode 'ps-remote-user'))
            $Tokens.Add('env-subscription-id', (Get-PSPropertyValue $envNode 'subscription-id'))
            $Tokens.Add('env-vault', (Get-PSPropertyValue $envNode 'vault'))
        }
    }
    $Tokens.Add('modules', $modules)
}