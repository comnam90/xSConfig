Import-Module $PSScriptRoot\..\src\xSconfig.psm1 -Force

InModuleScope xSConfig {
    Describe 'Invoke-ClusterNodeMenu' {
        Context 'Non-HCI Node' {
            $ExtraData = Get-ScriptExtraData
            Mock Clear-Host {}
            Mock Read-Host { "" }
            Function Get-Header { param($1); $1 }
            function Get-MenuColumnPadding { Param($1, $2)" " }
            It "Should not throw" {
                { Invoke-ClusterNodeMenu -WarningAction SilentlyContinue } | Should -Not -Throw
            }
            It "Should return a warning - 'There are no cluster nodes available'" {
                Invoke-ClusterNodeMenu -WarningVariable CatchWarning -WarningAction SilentlyContinue | Out-Null
                $CatchWarning | Should -Be -ExpectedValue "There are no cluster nodes available"
            }
        }
        Context 'HCI Cluster' {
            $ExtraData = @{
                ClusterName            = ''
                S2DEnabled             = ''
                StorageSubSystemHealth = ''
                Nodes                  = @(
                    [pscustomobject]@{
                        Name  = 'Node1'
                        State = 0
                        Id    = 1
                    },
                    [pscustomobject]@{
                        Name  = 'Node2'
                        State = 1
                        Id    = 2
                    }
                    [pscustomobject]@{
                        Name  = 'Node3'
                        State = 2
                        Id    = 3
                    }
                    [pscustomobject]@{
                        Name  = 'Node4'
                        State = 3
                        Id    = 4
                    }
                )
            }
            Mock Clear-Host {}
            Mock Read-Host { "" }
            Function Get-Header { param($1); $1 }
            function Get-MenuColumnPadding { Param($1, $2)" " }
            $Response = Invoke-ClusterNodeMenu
            It "Should return 4 rows with nodes" {
                ($Response -match "\| Node\d.+").Count | Should -Be -ExpectedValue 4
            }
            $TestCases = @(
                @{Name = 'Node1';Status = 'Up'}
                @{Name = 'Node2';Status = 'Down'}
                @{Name = 'Node3';Status = 'Paused'}
                @{Name = 'Node4';Status = 'Joining'}
            )
            It "Should return <Name> with a status of '<Status>'" -TestCases $TestCases {
                param(
                    $Name,
                    $Status
                )
                $Response -match "\| $($Name)\s*\|\s$($Status)\s*.+" | Should -Be -ExpectedValue $true
            }
        }
    }
}
