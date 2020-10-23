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
            
            # Update Menu Items
            $MenuItemsScriptBlock = Get-Command -Name Get-MenuItems -Module SConfig | Select-Object -ExpandProperty ScriptBlock
            $AdditionalMenuItems = @"
    16) Extras

  $($Strings.MenuOptions_Prompt)
"@
            $UpdatedMenuItems = @"
                function Get-MenuItems {
                    $($MenuItemsScriptBlock.ToString().Replace('  $($Strings.MenuOptions_Prompt)', $AdditionalMenuItems))
                }
"@
    
            Invoke-Expression -Command $UpdatedMenuItems

            $SconfigScriptblock = Get-Command -Name Invoke-SConfig -Module SConfig | Select-Object -ExpandProperty ScriptBlock
            $UpdatedSconfigScriptblock = $SconfigScriptblock -replace '(switch \(Get\-MenuSelection\) \{)','$1
            "16" { Invoke-ExtrasMenu } '
            Invoke-Expression -Command $UpdatedSconfigScriptblock
            # This script's "main" function
            Invoke-SConfig
        }
    }
}