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
function Add-TokensFromConfig($ConfigPath, $Tokens, $Env)
{
    function Add-Var($Nodes, $NameProp = 'name', $ValueProp = 'value', $Prefix)
    {
        foreach ($node in $Nodes)
        {
            $name = $node."$NameProp"
            $value = $node."$ValueProp"
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
                    $pre = "$Prefix$($node.ParentNode.name)"
                }
            }

            if ($pre)
            {
                $kn = "$pre$name"
                Write-Host "Adding variable $kn : $value"
                if (!$Tokens.ContainsKey($kn))
                {
                    $Tokens.Add($kn, $value)
                }
            }
            else
            {
                if (!$Tokens.ContainsKey($name))
                {
                    Write-Host "Adding variable $name : $value"
                    $Tokens.Add($name, $value)
                }
            }
        }
    }

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
        }
        $nodes = $doc.SelectNodes("//system-user[@environment='$Env' or not(@environment)]")
        if ($nodes.Count -gt 0)
        {
            Add-Var $nodes -NameProp 'system-user' -ValueProp 'name' -Prefix 'system-user-'
        }
        $envNode = $doc.SelectSingleNode("//environment[@name='$Env']")
        if ($envNode)
        {
            $Tokens.Add('env-name', $envNode.'name')
            $Tokens.Add('env-group', $envNode.'group')
            $Tokens.Add('env-name-short', $envNode.'name-short')
            $Tokens.Add('env-name-suffix', $envNode.'name-suffix')
            $Tokens.Add('env-type', $envNode.'type')
            $Tokens.Add('env-active', $envNode.'active')
            $Tokens.Add('env-domain', $envNode.'domain')
            $Tokens.Add('env-domain-full', $envNode.'domain-full')
            $Tokens.Add('env-domain-description', $envNode.'description')
            $Tokens.Add('env-domain-owner', $envNode.'owner')
            $Tokens.Add('env-domain-notes', $envNode.'notes')
            $Tokens.Add('env-ps-remote-user', $envNode.'ps-remote-user')
            $Tokens.Add('env-subscription-id', $envNode.'subscription-id')
            $Tokens.Add('env-vault', $envNode.'vault')
        }
    }
}