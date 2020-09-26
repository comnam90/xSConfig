function Invoke-StoragePoolMenu {
    [cmdletbinding()]
    [OutputType('System.String')]
    param()
    do {
        Clear-Host
        Get-Header "Storage Pools"
        if ($Null -ieq $ExtraData['StoragePools']) {
            Write-Warning "There are no storage pools available"
        }
        else {
            "| Name                   | Status    | Free Space | Allocated Space | Size      |"
            "| ---------------------- | --------- | ---------- | --------------- | --------- |"
            @($ExtraData['StoragePools'] | Where-Object { $_.IsPrimordial -ne $true }).ForEach{
                $Pool = $PSItem
                if ($Pool.FriendlyName.Length -gt 22) {
                    $Name = $Pool.FriendlyName.SubString(0, 22)
                }
                else {
                    $Name = "$($Pool.FriendlyName)$(" "*(22-($Pool.FriendlyName.Length)))"
                }
                $Status = switch ($Pool.HealthStatus) {
                    0 { "Healthy" }
                    1 { "Warning" }
                    2 { "Unhealthy" }
                    5 { "Unknown" }
                    Default { $_ }
                }
                $FreeSpace = "{0:N0} %" -f ( ( 1 - ( $Pool.AllocatedSize / $Pool.Size ) ) * 100 )
                $AllocatedSpace = "{0:N0} %" -f ( ( $Pool.AllocatedSize / $Pool.Size ) * 100 )
                $Size = "{0:N1} TB" -f ( $Pool.Size / 1TB )
                "| $($Name) | $($Status)$(" " * (9 - $Status.Length)) | $($FreeSpace)$(" " * (10 - $FreeSpace.Length)) | $($AllocatedSpace)$(" " * (15 - $AllocatedSpace.Length)) | $($Size)$(" " * (9 - $Size.Length)) |"
            }
        }
        ""
        $return = Read-Host "Press enter to return to the previous menu"
    }until(
        $return -eq ""
    )
}