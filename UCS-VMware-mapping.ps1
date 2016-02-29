$nxucs = Import-Csv "C:\Users\emereonyes\Documents\UCS profiles\nxa.csv"

Connect-VIServer 172.28.134.71 
Connect-VIServer 172.28.134.69
$hostclustersarr = @()
foreach( $vmhost in $nxucs ) {

    $hostcluster = $null
    $hostcluster = Get-VMHost "$($vmhost.Name).ise.pos.net" | Get-Cluster | select name,Client 
    
    if($hostcluster -ne $null){
            $prop =  [PSCustomObject]@{
            "Host" = $vmhost.NAME
            "Cluster" = $hostcluster.Name
            "UCS Location" = $vmhost.Location
            "UCS Overall Status" = $vmhost.OverallStatus
            "vCenter Server" = $hostcluster.client.ServerUri.Split("@")[1]
            "Connection State" = (Get-VMHost "$($vmhost.NAME).ise.pos.net").ConnectionState
            "Note" = ""
            }
        }
        else
        {
             $prop =  [PSCustomObject]@{
             "Host" = $vmhost.NAME
             "Cluster" = "N/A"
             "UCS Location" = $vmhost.Location
             "UCS Overall Status" = $vmhost.OverallStatus
             "vCenter Server" = "N/A"
             "Connection State" = "N/A"
             "Note" = "Host not found in vCenter"
            }
        }
    
    $hostclustersarr += $prop
}

$hostclustersarr | Sort-Object "Cluster" | Export-Csv "C:\Users\emereonyes\Documents\UCS profiles\vmware-ucs-mapping.csv" -NoClobber -NoTypeInformation


