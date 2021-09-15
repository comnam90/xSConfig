function Invoke-xSConfig {
    [cmdletbinding()]
    param()
    begin {
	$SConfigModule = Get-Module -ListAvailable -Name *Sconfig | Where-object {$_.Name -ne 'xSConfig'}
        If ($null -eq $SConfigModule) {
            Throw "'SConfig' Module is missing. xSconfig cannot be used without it."
        }
        else {
            Import-Module $SConfigModule.Name
            $Module = Get-Module $SConfigModule.Name
        }
    }
    process {
        & $Module {
            # Pull in private functions to SConfig Module Scope
            if (Test-Path -Path $PSScriptRoot\..\Private\) {
                Get-ChildItem -Path $PSScriptRoot\..\Private\*-*.ps1 | ForEach-Object { . $_.FullName }
            } # IF
            
            # Update Menu Items
            $MenuItemsScriptBlock = Get-Command -Name Get-MenuItems -Module $SConfigModule.Name | Select-Object -ExpandProperty ScriptBlock
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

            $SconfigScriptblock = Get-Command -Name Invoke-SConfig -Module $SConfigModule.Name | Select-Object -ExpandProperty ScriptBlock
            $UpdatedSconfigScriptblock = $SconfigScriptblock -replace '(switch \(Get\-MenuSelection\) \{)','$1
            "16" { Invoke-ExtrasMenu } '
            Invoke-Expression -Command $UpdatedSconfigScriptblock
            # This script's "main" function
            Invoke-SConfig
        }
    }
}