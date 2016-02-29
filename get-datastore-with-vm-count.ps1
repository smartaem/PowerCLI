$datastores = Get-Datastore
$arr=@()
foreach($datastore in $datastores) {
    $vmcount = 0
  
    $ds = get-datastore $datastore.Name 
    $vmcount = $ds  | Get-VM | where {$_.powerstate -eq "PoweredOn"}  | Measure-Object
    if($vmcount.Count -gt 20){
    $prop =  [PSCustomObject]@{
             "Datastore" = $datastore.Name
             "Size" = $ds.CapacityGB
             "Powered-On VM Count" = $vmcount.Count
             }
             $arr += $prop
             $prop
    }
    

}

 $arr |  Export-Csv "C:\Users\emereonyes\Documents\UCS profiles\Datastores-gt-20V-vms-size.csv" -NoClobber -NoTypeInformation
