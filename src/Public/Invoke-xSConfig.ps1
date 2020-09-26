function Invoke-xSConfig {
    [cmdletbinding()]
    param()
    begin {
        If (-not (Get-Module SConfig -ListAvailable)) {
            Throw "'SConfig' Module is missing. xSconfig cannot be used without it."
        }
        else {
            Import-Module SConfig
            $Module = Get-Module SConfig
        }
    }
    process {
        & $Module {
            # Pull in private functions to SConfig Module Scope
            if (Test-Path -Path $PSScriptRoot\..\Private\) {
                Get-ChildItem -Path $PSScriptRoot\..\Private\*-*.ps1 | ForEach-Object { . $_.FullName }
            } # IF

            function Get-MenuSelection2 {
                [CmdletBinding()]Param()

                Clear-Host
                $MenuTitle = $Strings.Title + " " + $Data["CurrentOS"]
                $Header = Get-Header $($MenuTitle)
                $MenuItems = Get-MenuItems
                $AdditionalItems = @"
16) Extras

$($Strings.MenuOptions_Prompt)
"@
                $MenuItems = $MenuItems.Replace($Strings.MenuOptions_Prompt, $AdditionalItems)

                return Read-Host ($Header + $MenuItems)
            }

            # This script's "main" function
            function Invoke-SConfig2 {
                [CmdletBinding()]Param()

                $Data = Get-ScriptData
                do {
                    switch (Get-MenuSelection2) {
                        "1" { Set-DomainWorkGroup }
                        "2" { Set-ComputerName }
                        "3" { Add-LocalAdmin }
                        "4" { Set-RemoteManagement }
                        "5" { Set-UpdateSettings }
                        "6" { Invoke-DownloadInstallUpdates }
                        "7" { Set-RemoteDesktopSettings }
                        "8" { Set-NetworkSettings }
                        "9" { timedate.cpl }
                        "10" { Set-TelemetrySettings }
                        "11" { Invoke-WindowsActivation }
                        "12" { Invoke-LogOff }
                        "13" { Invoke-Restart }
                        "14" { Invoke-ShutDown }
                        "15" { Clear-Host; return }
                        "16" { Invoke-ExtrasMenu }
                    }
                } while ($true)
            }
            Invoke-SConfig2
        }
    }
}