function Invoke-VirtualDiskMenu {
    [cmdletbinding()]
    [OutputType('System.String')]
    param()
    do {
        Clear-Host
        Get-Header "Virtual Disks"
        if ($null -ieq $ExtraData['VirtualDisks']) {
            Write-Warning "There are no virtual disks available"
        }
        else {
            "| Name                   | Status    | Size       | Pool Size  |"
            "| ---------------------- | --------- | ---------- | ---------- |"
            @($ExtraData['VirtualDisks']).ForEach{
                $Disk = $PSItem
                if ($Disk.FriendlyName.Length -gt 22) {
                    $Name = $Disk.FriendlyName.SubString(0, 22)
                }
                else {
                    $Name = "$($Disk.FriendlyName)$(" "*(22-($Disk.FriendlyName.Length)))"
                }
                $Status = switch ($Disk.HealthStatus) {
                    0 { "Healthy" }
                    1 { "Warning" }
                    2 { "Unhealthy" }
                    5 { "Unknown" }
                    Default { $_ }
                }
                $Footprint = "{0:N2} TB" -f ( $Disk.FootprintOnPool / 1TB )
                $Size = "{0:N2} TB" -f ( $Disk.Size / 1TB )
                "| $($Name) | $Status | $($Size)$(" " * (10 - $Size.Length)) | $($Footprint)$(" " * (10 - $Footprint.Length)) |"
            }
        }
        ""
        $return = Read-Host "Press enter to return to the previous menu"
    }until(
        $return -eq ""
    )
}