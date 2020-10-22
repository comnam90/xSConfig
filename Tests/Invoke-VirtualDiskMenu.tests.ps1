
InModuleScope xSConfig {
    Describe 'Invoke-VirtualDiskMenu' {
        Context 'Non-HCI Node' {
            $ExtraData = Get-ScriptExtraData
            Mock Clear-Host {}
            Mock Read-Host { "" }
            Function Get-Header { param($1); $1 }
            function Get-MenuColumnPadding { Param($1, $2)" " }
            It "Should not throw" {
                { Invoke-VirtualDiskMenu -WarningAction SilentlyContinue } | Should -Not -Throw
            }
            It "Should return a warning - 'There are no virtual disks available'" {
                Invoke-VirtualDiskMenu -WarningVariable CatchWarning -WarningAction SilentlyContinue | Out-Null
                $CatchWarning | Should -Be -ExpectedValue "There are no virtual disks available"
            }
        }
        Context 'HCI Cluster' {
            $ExtraData = @{
                ClusterName            = ''
                S2DEnabled             = ''
                StorageSubSystemHealth = ''
                VirtualDisks           = @(
                    @{
                        FriendlyName    = 'Volume1'
                        HealthStatus    = 0
                        FootprintOnPool = 3TB
                        Size            = 1TB
                    }
                )
            }
            Mock Clear-Host {}
            Mock Read-Host { "" }
            Function Get-Header { param($1); $1 }
            function Get-MenuColumnPadding { Param($1, $2)" " }
            It "Should return a table row beginning with 'Volume1" {
                $Response = (Invoke-VirtualDiskMenu) -join "`n"
                $MatchString = [regex]::Escape("| Volume1")
                $Response | Should -Match -RegularExpression $MatchString
            }
        }
    }
}