# Need to import all the files first of course.

Set-Location "C:\OPEN_PROJECTS\PowerRestCLI\"

$FoundError = $false

$Directories = ("private", "public")
foreach ($Directory in $Directories)
{
    # Import the functions.
    $files = Get-ChildItem .\PowerRestCLI\$Directory
    foreach ($file in $files)
    {
        # Source the file
        $FileName = $file.Name
        Write-Output "Importing file $FileName"
        . .\PowerRestCLI\$Directory\$FileName
    }
    # Execute Pester for the Directory.
    $PesterResults = Invoke-pester .\tests\$Directory\*.ps1 -CodeCoverage .\PowerRestCLI\$Directory\*.ps1 -PassThru

    $MissedCommands = $PesterResults.CodeCoverage.NumberOfCommandsMissed
    $FailedCount = $PesterResults.FailedCount
    Write-Output "Missed commands: $MissedCommands - Failed Tests: $Failedcount"
    if (($MissedCommands -ne "0") -or ($FailedCount -ne "0"))
    {
        $FoundError = $true
        Write-Error "Not at 100% coverage for $Directory Directory, or a test failed. Review results!"
    }
    else
    {
        # No Missed commands.
        Write-Output "No missed commands for $Directory Directory. 100% coverage!"
    }
}
if ($FoundError -eq $true)
{
    # An error was found in the Unit tests.
    Write-Error "An error has been found in the unit Tests. Please review them before commiting the code."
} 
else
{
    # No failed Tests found, Code Coverage is 100%
    Write-Output "Tests cover 100% and all pass! Hooray!"
}