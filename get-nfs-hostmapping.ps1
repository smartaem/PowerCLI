$hostlist = "a0000-bkvi12a.ise.pos.net"
$arr=@()
foreach($vmhost in (Get-VMHost)){
    foreach($datastore in ($vmhost | get-datastore | Where-Object {$_.type -eq 'NFS'})){
        $prop =  [PSCustomObject]@{
            "ESX Host" = $vmhost.Name
            "Datastore" = $datastore.Name
            "Remote Path" = $datastore.RemotePath
            "NFS Filer" = $datastore.RemoteHost[0]
             }
             $arr += $prop
             $prop
        
    }

}
$arr |  Export-Csv "C:\Users\emereonyes\Documents\UCS profiles\NFS-RemoteHosts.csv" -NoClobber -NoTypeInformation
