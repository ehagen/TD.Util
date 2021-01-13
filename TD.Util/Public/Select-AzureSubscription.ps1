<#
.SYNOPSIS
Select the Azure subscription

.DESCRIPTION
Select the Azure subscription

.Example
Select-AzureSubscription -SubscriptionId 'myid'
#>
function Select-AzureSubscription([Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$SubscriptionId)
{
    Assert-AzureConnected

    $ctxList = Get-AzContext -ListAvailable
    foreach ($ctx in $ctxList)
    {
        if ($ctx.Subscription.Id -eq $SubscriptionId)
        {
            Write-Verbose "Select context: $($ctx.Name)"
            Select-AzContext -Name $ctx.Name
            return
        }
    }
    Throw "Azure subscription '$SubscriptionId' not found"
}