[cmdletbinding()]
param(
    [switch]$Bootstrap,
    [switch]$Test,
    [switch]$CodeCoverage
)

# Variables
$build = @{
    PesterVersion = [version]'4.10.1'
}

# Bootstrap step
if ($Bootstrap) {
    Write-Information "Validate and install required build pre-reqs"
    if ( $Build['PesterVersion'] -inotin (Get-Module Pester -ListAvailable).Version ) {
        Write-Warning 'Required "Pester" module is missing. Installing required "Pester" module...'
        Install-Module Pester -RequiredVersion $Build['PesterVersion'] -Force -Scope CurrentUser -SkipPublisherCheck
    }
    Import-Module Pester -RequiredVersion $Build['PesterVersion']
}

# Test step
if ($Test) {
    if ( [version]$Build['PesterVersion'] -inotin (Get-Module Pester -ListAvailable).Version ) {
        throw "Cannot find the required module 'Pester' version $($Build.PesterVersion)"
    }

    $ModuleFiles = Get-ChildItem -Path .\src -Recurse -Include "*.psm1", "*.ps1" | Select-Object -ExpandProperty FullName
    $results = Invoke-Pester -Script .\Tests -CodeCoverage $ModuleFiles -PassThru

    if ($CodeCoverage) {
        "Coverage: {0:N2} %" -f (($results.CodeCoverage.NumberOfCommandsExecuted / $results.CodeCoverage.NumberOfCommandsAnalyzed) * 100)
    }
}