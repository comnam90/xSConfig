Import-Module $PSScriptRoot\..\src\xSconfig.psm1 -Force

InModuleScope xSConfig {
    Describe 'Invoke-StoragePoolMenu' {
        Context 'Non-HCI Node' {
            $ExtraData = Get-ScriptExtraData
            Mock Clear-Host {}
            Mock Read-Host { "" }
            Function Get-Header { param($1); $1 }
            function Get-MenuColumnPadding { Param($1, $2)" " }
            It "Should not throw" {
                { Invoke-StoragePoolMenu -WarningAction SilentlyContinue } | Should -Not -Throw
            }
            It "Should return a warning - 'There are no storage pools available'" {
                Invoke-StoragePoolMenu -WarningVariable CatchWarning -WarningAction SilentlyContinue | Out-Null
                $CatchWarning | Should -Be -ExpectedValue "There are no storage pools available"
            }
        }
        Context 'HCI Cluster' {
            $ExtraData = @{
                ClusterName            = ''
                S2DEnabled             = ''
                StorageSubSystemHealth = ''
                StoragePools           = @(
                    [pscustomobject]@{
                        FriendlyName  = 'S2D on S2D-Cluster'
                        HealthStatus  = 0
                        AllocatedSize = 10TB
                        Size          = 30TB
                    }
                )
            }
            Mock Clear-Host {}
            Mock Read-Host { "" }
            Function Get-Header { param($1); $1 }
            function Get-MenuColumnPadding { Param($1, $2)" " }
            It "Should return a table row beginning with 'S2D on S2D-Cluster" {
                $Response = (Invoke-StoragePoolMenu) -join "`n"
                $MatchString = [regex]::Escape("| S2D on S2D-Cluster")
                $Response | Should -Match -RegularExpression $MatchString
            }
            It "Should trim a friendly name with more than 22 characters" {
                $LongName = "S2D on Cluster-to-long-to-read"
                $MatchString =[regex]::Escape(($LongName.SubString(0,22)))
                $ExtraData['StoragePools'][0].Friendlyname = $LongName
                $Response = (Invoke-StoragePoolMenu) -join "`n"
                $Response | Should -Match -RegularExpression $MatchString
            }
        }
    }
}