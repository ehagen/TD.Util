<#
.SYNOPSIS
Select the Azure default subscription

.DESCRIPTION
Select the Azure default subscription

.PARAMETER SubscriptionId
The Azure subscription Id

.Example
Select-AzureDefaultSubscription -SubscriptionId 'myid'
#>
function Select-AzureDefaultSubscription([Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$SubscriptionId)
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