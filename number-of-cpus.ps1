$vms = Get-VM
$arr=@()



$check = 6
foreach($vm in $vms){
    if($vm.NumCpu -gt $check){
        
        $prop =  [PSCustomObject]@{
             "VM Name" = $vm.Name
             "CPU Count" = $vm.NumCpu
         }
            $prop
             $arr += $prop
    }

}

$arr |  Export-Csv "C:\Users\emereonyes\Documents\UCS profiles\VMs-with-$($check)-CPUs.csv" -NoClobber -NoTypeInformation
