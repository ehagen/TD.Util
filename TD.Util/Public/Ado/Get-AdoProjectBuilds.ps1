function Get-AdoProjectBuilds
{
    param(
        [alias('u', 'Uri')][string]$AdoUri,
        [ValidateNotNullOrEmpty()][alias('t', 'Token', 'Pat')][string]$AdoAuthToken,
        [ValidateNotNullOrEmpty()]$Organization,
        $Project = '',
        $Filter = { $_ },
        [switch]$IncludeMissingBuilds,
        [switch]$NoDistinct,
        [string]$DetectScanningString = 'job: Security',
        $ApiVersion = '7.0'
    )
    $buildCollection = [System.Collections.ArrayList]::New()

    $params = @{
        Organization = $Organization
        Project      = $Project
        ApiVersion   = $ApiVersion
    }
    if ($AdoUri) { [void]$params.Add('AdoUri', $AdoUri) }
    if ($AdoAuthToken) { [void]$params.Add('AdoAuthToken', $AdoAuthToken) }

    if ([string]::IsNullOrEmpty($Project))
    {
        $projects = Get-AdoProjects @params
    }
    else
    {
        $projects = Get-AdoProjects @params -Project $Project
    }

    foreach ($prj in $projects)
    {
        $definitions = Get-AdoBuildDefinitions @params -Project $prj.name -Expand
        foreach ($definition in $definitions)
        {

            $ignore = $false
            $team = ''
            if (Test-PsProperty $definition 'variables')
            {
                if (Test-PsProperty $definition.variables 'team')
                {
                    $team = $definition.variables.Team.value
                }
                if (Test-PsProperty $definition.variables 'ignore-build')
                {
                    $ignore = ($definition.variables.'Ignore-build'.value -eq 'true' )
                }
            }
            if ($ignore) { continue; }

            $procType = -1
            $procYaml = ''
            if (Test-PsProperty $definition 'process')
            {
                if (Test-PsProperty $definition.process 'type')
                {
                    $procType = $definition.process.type
                    $procYaml = if ($procType -eq 2 ) { $definition.process.yamlFilename } else { '' }
                }
            }

            $added = $false
            $builds = Get-AdoBuilds @params -Project $prj.name -DefinitionId $definition.id
            $totalBuilds = $builds.count
            $cnt = 0
            $builds | Where-Object $Filter | ForEach-Object {
                if (!($NoDistinct.IsPresent) -and ($cnt -ge 1) ) { return }
                $added = $true
                if (Test-PsProperty -o $_ -p startTime) { $startTime = [DateTime]$_.startTime } else { $startTime = [DateTime]$definition.createdDate }
                if (Test-PsProperty -o $_ -p finishTime) { $finishTime = [DateTime]$_.finishTime } else { $finishTime = [DateTime]$definition.createdDate }
                if (Test-PsProperty -o $_ -p queueTime) { $queueTime = [DateTime]$_.queueTime } else { $queueTime = [DateTime]$definition.createdDate }
                if (Test-PsProperty -o $_ -p result -Exact $true) { $result = $_.result } else { $result = '' }
                $duration = $finishTime - $startTime
                try
                {
                    # we use optimalization here and asume we always have logId 1
                    $log = Get-AdoBuildLog @params -Project $prj.Name -Id $_.id -LogId 1 #$build.Id
                }
                catch
                {
                    $log = ''
                }
                $hasScanning = $log.Contains($DetectScanningString)
                [void]$buildCollection.Add([PSCustomObject]@{
                        Project     = $_.project.name
                        Definition  = $_.definition.name
                        Team        = $team
                        Name        = $_.buildNumber
                        Id          = $_.id
                        BuildNumber = $_.buildNumber
                        Status      = $_.status
                        Result      = $result
                        StartTime   = $startTime
                        FinishTime  = $FinishTime
                        QueueTime   = $queueTime
                        Duration    = $duration
                        Branch      = $_.sourceBranch
                        Tags        = $_.tags
                        Reason      = $_.reason
                        Url         = $_.url
                        WebUrl      = $_._links.web.href
                        DefUrl      = $definition._links.web.href
                        Object      = $_
                        ProcessType = $procType
                        ProcessYaml = $procYaml
                        TotalBuilds = $totalBuilds
                        User        = $_.requestedBy.displayName
                        Missing     = $false
                        Log         = $log
                        HasScanning = $hasScanning
                    })
                $cnt++
            }

            if ($IncludeMissingBuilds.IsPresent -and !$added -and (-not($definition.Name.StartsWith('xxx'))) )
            {
                $startTime = [DateTime]$definition.createdDate
                $finishTime = [DateTime]$definition.createdDate
                $queueTime = [DateTime]$definition.createdDate
                $result = ''
                $branch = ''
                $duration = ''
                $user = ''
                if ($totalBuilds -gt 0)
                {
                    $lastBuild = $builds | Select-Object -First 1
                    if ($lastBuild)
                    {
                        if (Get-HasPsProperty -o $lastBuild -p startTime) { $startTime = [DateTime]$lastBuild.startTime }
                        if (Get-HasPsProperty -o $lastBuild -p finishTime) { $finishTime = [DateTime]$lastBuild.finishTime }
                        if (Get-HasPsProperty -o $lastBuild -p queueTime) { $queueTime = [DateTime]$lastBuild.queueTime }
                        $duration = $finishTime - $startTime
                        #if (Get-HasPsProperty -o $lastBuild -p result -Exact $true) { $result = $lastBuild.result }
                        #$branch = $lastBuild.sourceBranch
                        $user = $lastBuild.requestedBy.displayName
                    }
                }
                [void]$buildCollection.Add([PSCustomObject]@{
                        Project     = $prj.name
                        Definition  = $definition.name
                        Team        = $team
                        Name        = ''
                        Id          = -1
                        BuildNumber = ''
                        Status      = 'notStarted'
                        Result      = $result
                        StartTime   = $startTime
                        FinishTime  = $finishTime
                        QueueTime   = $queueTime
                        Duration    = $duration
                        Branch      = $branch
                        Tags        = ''
                        Reason      = 'undefined'
                        Url         = $definition.url
                        WebUrl      = ''
                        DefUrl      = $definition._links.web.href
                        Object      = $definition
                        ProcessType = $procType
                        ProcessYaml = $procYaml
                        TotalBuilds = $totalBuilds
                        User        = $user
                        Missing     = $true
                        HasScanning = $false
                    })
            }
        }
    }
    return , ($buildCollection | Sort-Object -Property Project, Definition, Name, Status, Result, @{Expression = 'FinishTime'; Descending = $true })
}
