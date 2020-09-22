
Import-Module $PSScriptRoot\..\src\xSconfig.psm1 -Force

InModuleScope -ModuleName xSConfig {
    Describe "Get-ScriptExtraData" {
        Context "Non-HCI Node" {
            It "Should return Unknown values" {
                $response = Get-scriptextradata
                $response['ClusterName'] | Should -Be -ExpectedValue 'Unknown'
                $response['StorageSubSystemHealth'] | Should -Be -ExpectedValue 'Unknown'
                $response['S2DEnabled'] | Should -Be -ExpectedValue 'Unknown'
            }
        }
        Context "HCI Cluster" {
            Mock Get-CimInstance -ParameterFilter { $Namespace -ieq "root\mscluster" -and $ClassName -ieq "mscluster_cluster" } -MockWith {
                [pscustomobject]@{
                    Name       = 'S2D-Cluster'
                    S2DEnabled = 1
                }
            }
            Mock Get-CimInstance -ParameterFilter { $Namespace -ieq "root\mscluster" -and $ClassName -ieq "mscluster_node" } -MockWith {
                [pscustomobject]@{
                    Name  = 'Node01'
                    State = 1
                    ID    = 1
                }
            }
            Mock Get-CimInstance -ParameterFilter { $Namespace -ieq "ROOT\Microsoft\Windows\Storage" -and $ClassName -ieq "MSFT_StorageSubSystem" } -MockWith {
                [pscustomobject]@{
                    Name         = 'S2D-Cluster.fqdn.domain'
                    HealthStatus = 0
                }
            }
            Mock Get-CimInstance -ParameterFilter { $Namespace -ieq "ROOT\Microsoft\Windows\Storage" -and $ClassName -ieq "MSFT_StoragePool" } -MockWith {
                [pscustomobject]@{
                    IsPrimordial  = $false
                    FriendlyName  = 'S2D on S2D-Cluster'
                    HealthStatus  = '0'
                    AllocatedSize = 100GB
                    Size          = 1TB
                }
            }
            Mock Get-CimInstance -ParameterFilter { $Namespace -ieq "ROOT\Microsoft\Windows\Storage" -and $ClassName -ieq "MSFT_VirtualDisk" } -MockWith {
                [pscustomobject]@{
                    FriendlyName    = 'Volume1'
                    HealthStatus    = '0'
                    FootprintOnPool = 3TB
                    Size            = 1TB
                }
            }

            It "Should return a cluster name" {
                $response = Get-scriptextradata
                $response.ClusterName | Should -Not -Be -ExpectedValue 'Unknown'
            }
            It "Should return S2D Enabled" {
                $response = Get-scriptextradata
                $response.S2DEnabled | Should -Be -ExpectedValue 'Yes'
            }
            It "Should return a healthy subsystem" {
                $response = Get-scriptextradata
                $response.StorageSubSystemHealth | Should -Be -ExpectedValue 'Healthy'
            }
            It "Should return a warning subsystem" {
                Mock Get-CimInstance -ParameterFilter { $Namespace -ieq "ROOT\Microsoft\Windows\Storage" -and $ClassName -ieq "MSFT_StorageSubSystem" } -MockWith {
                    [pscustomobject]@{
                        Name         = 'S2D-Cluster.fqdn.domain'
                        HealthStatus = 1
                    }
                }
                $response = Get-scriptextradata
                $response.StorageSubSystemHealth | Should -Be -ExpectedValue 'Warning'
            }
            It "Should return an unhealthy subsystem" {
                Mock Get-CimInstance -ParameterFilter { $Namespace -ieq "ROOT\Microsoft\Windows\Storage" -and $ClassName -ieq "MSFT_StorageSubSystem" } -MockWith {
                    [pscustomobject]@{
                        Name         = 'S2D-Cluster.fqdn.domain'
                        HealthStatus = 2
                    }
                }
                $response = Get-scriptextradata
                $response.StorageSubSystemHealth | Should -Be -ExpectedValue 'Unhealthy'
            }
            It "Should return an Unknown subsystem" {
                Mock Get-CimInstance -ParameterFilter { $Namespace -ieq "ROOT\Microsoft\Windows\Storage" -and $ClassName -ieq "MSFT_StorageSubSystem" } -MockWith {
                    [pscustomobject]@{
                        Name         = 'S2D-Cluster.fqdn.domain'
                        HealthStatus = 5
                    }
                }
                $response = Get-scriptextradata
                $response.StorageSubSystemHealth | Should -Be -ExpectedValue 'Unknown'
            }
            It "Should return S2D Disabled" {
                Mock Get-CimInstance -ParameterFilter { $Namespace -ieq "root\mscluster" -and $ClassName -ieq "mscluster_cluster" } -MockWith {
                    [pscustomobject]@{
                        Name       = 'S2D-Cluster'
                        S2DEnabled = 0
                    }
                }
                $response = Get-scriptextradata
                $response.S2DEnabled | Should -Be -ExpectedValue 'No'
            }
        } #Context
    }
}
