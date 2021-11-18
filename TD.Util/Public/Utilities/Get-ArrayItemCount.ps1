function Get-ArrayItemCount($Array)
{
    if ($Array -is [array] -or $Array -is [System.Collections.ArrayList])
    {
        return $Array.Count
    }
    elseif ($Array)
    {
        return 1
    }
    else
    {
        return 0;
    }
}