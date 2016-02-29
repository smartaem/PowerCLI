
$vCenter="192.168.10.200"
$vCenterUser="administrator@vsphere.local"
$vCenterUserPassword="Password1!"
#
# Specify number of VMs you want to create
$vm_count = "50"

$clone = "master"

$customspecification= "EVOLAB"

$ds = "MARVIN-Virtual-SAN-Datastore-12b6c492-2dc1-4ae8-b477-5be08809d5ce"

$Folder = "EVOLAB"

$Cluster = "MARVIN-Virtual-SAN-Cluster-12b6c492-2dc1-4ae8-b477-5be08809d5ce"

$VM_prefix = “EVOLAB-"

$taskTab = @{}

Connect-viserver $vCenter -user $vCenterUser -password $vCenterUserPassword -WarningAction 0
1..$vm_count | foreach
{
	$y="{0:D2}" -f $_
	$VM_name = $VM_prefix + $y
	$ESXi=Get-Cluster $Cluster | Get-VMHost -state connected | Get-Random
	write-host "Creation of VM $VM_name initiated" -foreground green
	$taskTab[(New-VM -Name $VM_Name -VM $clone -VMHost $ESXi -Datastore $ds -Location $Folder -OSCustomizationSpec $customspecification -RunAsync).Id] = $VM_name

}

# Start each VM that is completed
$runningTasks = $taskTab.Count
while($runningTasks -gt 0){
  Get-Task | % {
    if($taskTab.ContainsKey($_.Id) -and $_.State -eq "Success"){
      Get-VM $taskTab[$_.Id] | Start-VM
      $taskTab.Remove($_.Id)
      $runningTasks--
    }
    elseif($taskTab.ContainsKey($_.Id) -and $_.State -eq "Error"){
      $taskTab.Remove($_.Id)
      $runningTasks--
    }
  }
  Start-Sleep -Seconds 15
}