$files = git ls-files

function update-sed {
    param (
        [string[]]$pattern,
        [string[]]$files
    )
    $files | ForEach-Object -Parallel {
        #Write-Host "Applying pattern: ${using:pattern} to ${_}"
        sed -i @using:pattern ${_}
        exit
    }
}
# TODO: combine multiple patterns per call to sed
$patterns = @()
Get-Content ./replacements.txt | ForEach-Object {
    if ($_)
    {
        $patterns += @("-e", $_)

        if ($patterns.Length -ge 20)
        {
            update-sed $patterns -files $files
            $patterns = @() # reset patterns
        }
    }
}
update-sed $patterns -files $files
