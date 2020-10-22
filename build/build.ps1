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
    
    if (-not (Get-Module -Name PSCodeCovIo -ListAvailable)) {
        Write-Warning "Module 'PSCodeCovIo' is missing. Installing 'PSCodeCovIo' ..."
        Install-Module -Name PSCodeCovIo -Scope CurrentUser -Force
    }
}

# Test step
if ($Test) {
    if ( [version]$Build['PesterVersion'] -inotin (Get-Module Pester -ListAvailable).Version ) {
        throw "Cannot find the required module 'Pester' version $($Build.PesterVersion)"
    }

    if (-not (Get-Module -Name PSCodeCovIo -ListAvailable)) {
        throw "Cannot find the 'PSCodeCovIo' module. Please specify '-Bootstrap' to install build dependencies."
    }

    Import-Module $PSScriptRoot\..\src\xSConfig.psm1 -Force

    $ModuleFiles = Get-ChildItem -Path .\src -Recurse -Include "*.ps1" | Select-Object -ExpandProperty FullName
    
    if ($env:TF_BUILD) {
        $results = Invoke-Pester "./Tests" -OutputFormat NUnitXml -OutputFile TestResults.xml -CodeCoverage $ModuleFiles -CodeCoverageOutputFileFormat 'JaCoCo' -CodeCoverageOutputFile "$Env:AgentTemp\CoverageResults.xml" -PassThru
        if ($results.FailedCount -gt 0) { throw "$($results.FailedCount) tests failed." }
    } else {
        $results = Invoke-Pester -Script "./Tests" -CodeCoverage $ModuleFiles -PassThru
    }

    if ($CodeCoverage) {
        Export-CodeCovIoJson -CodeCoverage $results.CodeCoverage -RepoRoot $pwd -Path coverage.json

        Invoke-WebRequest -Uri 'https://codecov.io/bash' -OutFile codecov.sh
    }
}