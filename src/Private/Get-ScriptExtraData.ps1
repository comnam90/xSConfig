
function Get-ScriptExtraData {
    [cmdletbinding()]
    [outputtype('System.Collections.Hashtable')]
    param()
    $Data = @{
        ClusterName            = 'Unknown'
        S2DEnabled             = 'Unknown'
        StorageSubSystemHealth = 'Unknown'
    }
    $MSCluster = Get-CimInstance -ClassName mscluster_cluster -Namespace root\mscluster -ErrorAction SilentlyContinue
    if ($MSCluster) {
        $Data['ClusterName'] = $MSCluster.Name
        if ($MSCluster.S2DEnabled -eq 1) {
            Try {
                $SSS = Get-CimInstance -ClassName MSFT_StorageSubSystem -Namespace ROOT\Microsoft\Windows\Storage | Where-Object { $_.Name -ilike "$($Data['ClusterName'])*" }
                $SP = Get-CimInstance -ClassName MSFT_StoragePool -Namespace ROOT\Microsoft\Windows\Storage | Where-Object { $_.IsPrimordial -ne $true }
                $VDs = Get-CimInstance -ClassName MSFT_VirtualDisk -Namespace ROOT\Microsoft\Windows\Storage
                $Nodes = Get-CimInstance -Namespace root\mscluster -ClassName MSCluster_Node
            }
            catch {
                Write-Warning $Strings.Error
                Write-Warning $_
                Read-Host $Strings.AnyKey
            }
            $Data['S2DEnabled'] = 'Yes'
            $Data['StorageSubSystemHealth'] = switch ($SSS.HealthStatus) {
                0 { 'Healthy' }
                1 { 'Warning' }
                2 { 'Unhealthy' }
                Default { 'Unknown' }
            }
            $Data['StoragePools'] = $SP
            $Data['VirtualDisks'] = $VDs
            $Data['Nodes'] = $Nodes
        }
        else {
            $Data['S2DEnabled'] = 'No'
        }
    }
    return $Data
}