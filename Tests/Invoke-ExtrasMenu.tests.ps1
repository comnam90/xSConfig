Import-Module $PSScriptRoot\..\src\xSconfig.psm1 -Force

InModuleScope xSConfig {
    Describe "Invoke-ExtrasMenu" {
        Mock Read-Host {
            Write-Output ""
        }
        Mock Clear-Host {}
        Function Get-Header { param($1); $1 }
        function Get-MenuColumnPadding { Param($1, $2)" " }
        Context 'Non-HCI Node' {
            # Join with Newlines otherwise regex matches fail to return bool for array.
            $Response = (Invoke-ExtrasMenu) -join "`n"
            It "Should have Unknown Cluster Name" {
                $Response | Should -Match -RegularExpression "Cluster Name:\s+Unknown"
            }
            It "Should have Unknown S2D Enabled Status" {
                $Response | Should -Match -RegularExpression "S2D Enabled:\s+Unknown"
            }
            It "Should have Unknown StorageSubSystem Health Status" {
                $Response | Should -Match -RegularExpression "StorageSubSystem Health:\s*Unknown"
            }
            It "Should have 0 Storage Pools" {
                $Response | Should -Match -RegularExpression "0 Pools"
            }
            It "Should have 0 Virtual Disks" {
                $Response | Should -Match -RegularExpression "0 Disks"
            }
            It "Should have 0 Cluster Nodes" {
                $Response | Should -Match -RegularExpression "0 Nodes"
            }
        }
        Context 'HCI Cluster' {
            Mock Get-ScriptExtraData {
                @{
                    ClusterName            = 'S2D-Cluster'
                    S2DEnabled             = 'Yes'
                    StorageSubSystemHealth = 'Healthy'
                    StoragePools           = @(
                        [pscustomobject]@{}
                    )
                    VirtualDisks           = @(
                        [pscustomobject]@{},
                        [pscustomobject]@{}
                    )
                    Nodes                  = @(
                        [pscustomobject]@{},
                        [pscustomobject]@{},
                        [pscustomobject]@{}
                    )
                }
            } -Verifiable
            $Response = (Invoke-ExtrasMenu) -join "`n"
            It "Should have Cluster Name 'S2D-Cluster'" {
                $Response | Should -Match -RegularExpression "Cluster Name:\s+S2D\-Cluster"
            }
            It "Should have S2D Enabled Status 'Yes'" {
                $Response | Should -Match -RegularExpression "S2D Enabled:\s+Yes"
            }
            It "Should have StorageSubSystem Health Status 'Healthy'" {
                $Response | Should -Match -RegularExpression "StorageSubSystem Health:\s*Healthy"
            }
            It "Should have 1 Storage Pools" {
                $Response | Should -Match -RegularExpression "1 Pools"
            }
            It "Should have 2 Virtual Disks" {
                $Response | Should -Match -RegularExpression "2 Disks"
            }
            It "Should have 3 Cluster Nodes" {
                $Response | Should -Match -RegularExpression "3 Nodes"
            }
        }
    }
}
