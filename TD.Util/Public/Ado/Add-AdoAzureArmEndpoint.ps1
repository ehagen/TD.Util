function Add-AdoAzureArmEndpoint
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        $Organization,
        $Project,
        $ProjectId,
        $ApiVersion = '6.0-preview.4',
        $Name,
        $SubscriptionId,
        $SubscriptionName,
        $TenantId,
        $ServicePrincipalId,
        $ServicePrincipalKey    )

    $endPoint = @{
        data                             = @{
            subscriptionId   = $SubscriptionId
            subscriptionName = $SubscriptionName
            environment      = "AzureCloud"
            scopeLevel       = "Subscription"
            creationMode     = "Manual"
        }
        name                             = $Name
        type                             = "AzureRM"
        url                              = "https=//management.azure.com/"
        authorization                    = @{
            parameters = @{
                tenantid            = $TenantId
                serviceprincipalid  = $ServicePrincipalId
                authenticationType  = "spnKey"
                serviceprincipalkey = $ServicePrincipalKey
            }
            scheme     = "ServicePrincipal"
        }
        isShared                         = $false
        isReady                          = $true
        serviceEndpointProjectReferences = @(
            @{
                projectReference = @{
                    id   = $ProjectId
                    name = $Project
                }
                name             = $Name
            }
        )
    }
    # alternative: az devops service-endpoint create
    #     $endPoint = @"
    # {
    #     "data": {
    #         "subscriptionId": "$SubscriptionId",
    #         "subscriptionName": "$SubscriptionName",
    #         "environment": "AzureCloud",
    #         "scopeLevel": "Subscription",
    #         "creationMode": "Manual"
    #     },
    #     "name": "$Name",
    #     "type": "AzureRM",
    #     "url": "https://management.azure.com/",
    #     "authorization": {
    #         "parameters": {
    #         "tenantid": "$TenantId",
    #         "serviceprincipalid": "$ServicePrincipalId",
    #         "authenticationType": "spnKey",
    #         "serviceprincipalkey": "$ServicePrincipalKey"
    #         },
    #         "scheme": "ServicePrincipal"
    #     },
    #     "isShared": false,
    #     "isReady": true,
    #     "serviceEndpointProjectReferences": [
    #         {
    #         "projectReference": {
    #             "id": "$ProjectId",
    #             "name": "$Project"
    #         },
    #         "name": "$Name"
    #         }
    #     ]
    # }
    # "@

    $res = Add-AdoEndpoint -u $Uri -t $AdoAuthToken -Organization $Organization -Project $Project -EndPoint $endPoint -ApiVersion $ApiVersion
    return $res
}