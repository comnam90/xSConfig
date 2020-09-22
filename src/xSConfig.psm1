#requires -version 3.0
#requires -module SConfig

Get-ChildItem -Path $PSScriptRoot\Public\*-*.ps1 | ForEach-Object { . $_.FullName }
if (Test-Path -Path $PSScriptRoot\Private\) {
    Get-ChildItem -Path $PSScriptRoot\Private\*-*.ps1 | ForEach-Object { . $_.FullName }
} # IF
#
