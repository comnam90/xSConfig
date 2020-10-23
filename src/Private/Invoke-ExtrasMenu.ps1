function Invoke-ExtrasMenu {
    [cmdletbinding()]
    [OutputType('System.String')]
    param()
    begin {
        # Get extra data
        $ExtraData = Get-ScriptExtraData
    }
    process {
        Do {
            Clear-Host
            Get-Header "Extras Menu"
            "Cluster Name:$(Get-MenuColumnPadding 'Cluster Name:')$($ExtraData['ClusterName'])"
            "S2D Enabled:$(Get-MenuColumnPadding 'S2D Enabled:')$($ExtraData['S2DEnabled'])"
            "StorageSubSystem Health:$(Get-MenuColumnPadding 'StorageSubSystem Health:')$($ExtraData['StorageSubSystemHealth'])"
            ""
            "1) Storage Pools$(Get-MenuColumnPadding '    Storage Pools')$(($ExtraData['StoragePools'] | Measure-Object).Count) Pools"
            "2) Virtual Disks$(Get-MenuColumnPadding '    Virtual Disks')$(($ExtraData['VirtualDisks'] | Measure-Object).Count) Disks"
            "3) Cluster Nodes$(Get-MenuColumnPadding '    Cluster Nodes')$(($ExtraData['Nodes'] | Measure-Object).Count) Nodes"
            ""
            $return = Read-Host "Enter number to select an option(BLANK=Cancel)"
            Switch ($return) {
                1 { Invoke-StoragePoolMenu }
                2 { Invoke-VirtualDiskMenu }
                3 { Invoke-ClusterNodeMenu }
            }
        }until(
            $return -eq ""
        )
    }
}