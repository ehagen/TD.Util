function Invoke-AdoQueuePipeline
{
    # Remark: To use templatedParameters you need to supply all parameters. Tip: use browser dev console tools to see usage of call in ADO Web Application
    # ref: https://learn.microsoft.com/en-us/rest/api/azure/devops/pipelines/runs/run-pipeline?view=azure-devops-rest-7.0
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        $Organization,
        $Project,
        $Id,
        $Branch,
        [HashTable]$Parameters,
        [HashTable]$Variables,
        [Array]$StagesToSkip,
        [Switch]$Preview,
        [Switch]$Debug,
        $ApiVersion = '7.0')

    $body = @{}

    if ($Branch)
    {
        $body.resources = @{
            "repositories" = @{
                "self" = @{
                    "refName" = $Branch
                }
            }
        }
    }

    if ($Preview)
    {
        $body.previewRun = $true
    }

    if ($StagesToSkip)
    {
        $body.stagesToSkip = $StagesToSkip
    }

    if ($Parameters)
    {
        $body.templateParameters = $Parameters
    }
    else
    {
        $body.templateParameters = @{}
    }

    if ($Variables)
    {
        $body.variables = $Variables
    }
    else
    {
        $body.variables = @{}
    }
    if ($Debug)
    {
        $body.variables.'system.debug' = $true
        $body.variables.'agent.diagnostic' = $true
    }

    $url = "$(Get-AdoUri $AdoUri $Project $Organization)/_apis/pipelines/$($Id)/runs?api-version=$ApiVersion"
    $build = Get-AdoApiResult -AdoUri $url -AdoAuthToken $AdoAuthToken -Method Post -Body ($body | ConvertTo-Json -Depth 10 -Compress) -ContentType 'application/json'
    return $build
}
