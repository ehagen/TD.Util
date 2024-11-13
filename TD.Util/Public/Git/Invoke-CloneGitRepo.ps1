function Invoke-CloneGitRepo($Root, $RepoUrl, [switch]$Reset, $RepoName, $RepoDefaultBranch, $Depth = 0)
{
	New-Item -Path $Root -ItemType Directory -ErrorAction Ignore -Force | Out-Null

	$uri = [System.Uri]$RepoUrl
	if ($uri.Segments.Count -gt 0)
	{
		$defBranch = 'master'
		$folder = $uri.Segments[$uri.Segments.Count - 1]
		$repoLocation = Join-Path $Root $folder
		Write-Host "Repo: $repoLocation"
		if (Test-Path $repoLocation)
		{
			Push-Location -Path $repoLocation
			try
			{
				$output = &git status
				if ($output)
				{
					Write-Host $output
					$hasChanges = !$output.Contains("nothing to commit, working tree clean")
					if ($reset.IsPresent)
					{
						&git reset --hard
						&git clean -xdf
						$hasChanges = $false
					}
					if (!$hasChanges)
					{
						#&git fetch
						Invoke-Git "fetch"

						# detect main branch name
						#&git branch --remotes --list '*/HEAD'
						$br = Invoke-Git "branch --remotes --list '*/HEAD'"
						if ($null -ne $br -and $br.Contains('/main'))
						{
							$defBranch = 'main'
						}

						#&git checkout master
						Invoke-Git "checkout $defBranch"
						#&git pull
						Invoke-Git "pull"
						Write-Host -ForegroundColor Green "    Repo $($RepoName) switched to $defBranch and updated."
					}
					else
					{
						Write-Host -ForegroundColor Yellow "    Repo $($RepoName) contains changes."
					}
				}
				else
				{
					Write-Host -ForegroundColor Yellow "    Repo $($RepoName) not found, no .git folder? or no repo?"
				}
			}
			finally
			{
				Pop-Location
			}
		}
		else
		{
			Write-Host -ForegroundColor Yellow "    Repo $($RepoName) not found locally. Cloning..."
			Push-Location $Root
			try
			{
				#&git clone $r.RemoteUrl
				if ($Depth -gt 0)
				{
					Invoke-Git "clone --depth $($Depth) $($RepoUrl)"
				}
				else
				{
					Invoke-Git "clone $($RepoUrl)"

					$folder = $uri.Segments[$uri.Segments.Count - 1]
					$repoLocation = Join-Path $Root $folder
					if ( (Test-Path $repoLocation) -and ($RepoDefaultBranch -ne ''))
					{
						Push-Location $repoLocation
						try
						{
							# detect main branch name
							#&git branch --remotes --list '*/HEAD'
							$br = Invoke-Git "branch --remotes --list '*/HEAD'"
							if ($null -ne $br -and $br.Contains('/main'))
							{
								$defBranch = 'main'
							}

							#&git checkout master
							Invoke-Git "checkout $defBranch"
						}
						finally
						{
							Pop-Location
						}
					}
					else
					{
						Write-Warning "Repo $($RepoName) not cloned see error above"
					}
				}
			}
			finally
			{
				Pop-Location
			}
		}
	}
}
