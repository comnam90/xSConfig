Function Invoke-ClusterNodeMenu {
    [cmdletbinding()]
    [OutputType('System.String')]
    param()
    do {
        Clear-Host
        Get-Header "Cluster Nodes"
        if ($null -ieq $ExtraData['Nodes']) {
            Write-Warning "There are no cluster nodes available"
        }
        else {
            "| Name                   | Status    | ID   |"
            "| ---------------------- | --------- | ---- |"
            @($ExtraData['Nodes']).Foreach{
                $Node = $PSItem
                $Name = "$($Node.Name)$(" " * (22 - $Node.Name.Length))"
                $Status = Switch ($Node.State) {
                    0 { "Up       " }
                    1 { "Down     " }
                    2 { "Paused   " }
                    3 { "Joining  " }
                    default { "Unknown  " }
                }
                $ID = "$($Node.Id)$(" " * ( 4 - $Node.Id.Length ) )"
                "| $Name | $Status | $ID |"
            }
        }
        ""
        $return = Read-Host "Press enter to return to the previous menu"
    }until(
        $Return -eq ""
    )
}