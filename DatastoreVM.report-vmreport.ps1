
$volumelist = @("MG11_01a_sas_aggr0_BofA_DR",
"MG11_01a_sas_aggr0_BofA_DR_DMZ",
"DS_01a_sas_aggr0_ADVSQL_PMONDB01",
"DS_01a_sas_aggr0_ADV_PMONDB01",
"DS_01a_sas_aggr0_ADV_PSQLS013",
"DS_01a_sas_aggr0_ADV_PSQLS015",
"DS_01a_sas_aggr0_ADV_PSQLS019",
"DS_01a_sas_aggr0_ADV_SQLC001",
"DS_01a_sas_aggr0_ADV_SQLC002",
"DS_01a_sas_aggr0_ADV_SQLC003",
"DS_01a_sas_aggr0_ADV_SQLC004",
"DS_01a_sas_aggr0_ADV_SQLC005",
"DS_01a_sas_aggr0_ADV_SQLC006",
"DS_01a_sas_aggr0_ARCSQL_CMD4_PCMDD005",
"DS_01a_sas_aggr0_ARCSQL_CMD4_PCMDD006",
"DS_01a_sas_aggr0_ARCSQL_CMD5_PCMDD007",
"DS_01a_sas_aggr0_ARCSQL_CMD5_PCMDD008",
"DS_01a_sas_aggr0_ARCSQL_OR1SVM_PCMDD005",
"DS_01a_sas_aggr0_ARCSQL_OR1SVM_PCMDD006",
"DS_01a_sas_aggr0_BofA_DR_DMZ",
"DS_01a_sas_aggr0_CMD4",
"DS_01a_sas_aggr0_CMD5",
"DS_01a_sas_aggr0_VCACitiDMZ_PCI1_DMZ",
"DS_01a_sas_aggr0_VCACitiTrusted_P1",
"DS_01a_sas_aggr0_VCASharedDMZ_PCI1_DMZ",
"DS_01a_sas_aggr0_VCASharedTrusted_P1",
"DS_01a_sas_aggr0_VCATargetDMZ_PCI1_DMZ",
"DS_01a_sas_aggr0_VCATargetTrusted_P1",
"DS_01a_sas_aggr0_VCA_C03D01",
"DS_01a_sas_aggr0_bubble",
"DS_01a_sas_aggr0_snapmirrortest",
"DS_01a_sas_aggr0_vcaadvantageprod",
"DS_01a_sas_aggr0_vcaamexprod",
"DS_01a_sas_aggr0_vcacitiprod",
"DS_01a_sas_aggr0_vcasharedprod",
"DS_01a_sas_aggr0_vcatargetprod",
"DS_vsm1_rootvol",
"a0000psvi01_nfs1_orcc_migration",
"a0000psvi01_nfs1_orcc_srm",
"a0000psvi01_nfs1_vca_migration_prod",
"a0000psvi01_nfs1_vca_srm",
"DS_01a_sas_aggr0_BofA_DR",
"DS_01b_sas_aggr0_ADVARC_GroupC_DC",
"DS_01b_sas_aggr0_ADVARC_Tools_GroupC",
"DS_01b_sas_aggr0_ADVARC_Tools_GroupC_DMZ",
"DS_01b_sas_aggr0_ADVSQL_PSQLS017",
"DS_01b_sas_aggr0_ADVSQL_PSQLS018",
"DS_01b_sas_aggr0_ADV_PCSG0004",
"DS_01b_sas_aggr0_ADV_PMIS001",
"DS_01b_sas_aggr0_ARCSQL_C012",
"DS_01b_sas_aggr0_ARCSQL_C016",
"DS_01b_sas_aggr0_ARCSQL_CMD6_AR0100V_C6DB01",
"DS_01b_sas_aggr0_ARCSQL_CMD6_AR0100V_C6DB03",
"DS_01b_sas_aggr0_ARCSQL_CMD6_C6DB02",
"DS_01b_sas_aggr0_ARC_CMD2_DMZ_GroupC",
"DS_01b_sas_aggr0_ARC_CMD2_GroupC",
"DS_01b_sas_aggr0_ARC_CMD4_DMZ_GroupC",
"DS_01b_sas_aggr0_ARC_CMD4_GroupC",
"DS_01b_sas_aggr0_ARC_CMD5_DMZ_GroupC",
"DS_01b_sas_aggr0_ARC_CMD5_GroupC",
"DS_01b_sas_aggr0_ARC_CMD6_DMZ_GroupC",
"DS_01b_sas_aggr0_ARC_CMD6_GroupC",
"DS_01b_sas_aggr0_Advantage_GroupC",
"DS_01b_sas_aggr0_Advantage_GroupC_DMZ",
"DS_01b_sas_aggr0_Group_B",
"DS_01b_sas_aggr0_Group_C",
"DS_01b_sas_aggr0_ORCC_Placeholder",
"DS_01b_sas_aggr0_P2PSQL_A",
"DS_01b_sas_aggr0_P2P_ODDS")

# "DS_01b_sas_aggr0_ARC_PDCON_GroupC",
$VMSReport = @()
$report = @()


foreach($vol in $volumelist){

    if($test = Get-Datastore $vol -ErrorAction silentlycontinue)
    {
        Write-Host "Processing... $vol`n" 

        Get-VM -datastore $vol | foreach {

            $rep = New-Object System.Object 
            $vmname = $_.Name
            $view = get-view -ViewType virtualmachine -Filter @{"Name"=$vmname}
            $cluster = $view.summary.runtime.host | foreach {Get-VMHost -Id $_} | get-cluster
        
            $rep | Add-Member NoteProperty  -Name "Volume/Datastore Name" -Value  $vol
            $rep | Add-Member NoteProperty  -Name "VM Name" -Value  $vmname
            $rep | Add-Member NoteProperty  -Name "VM State" -Value  $view.Runtime.PowerState
            $rep | Add-Member NoteProperty  -Name "Cluster" -Value  $cluster


            $VMSReport += $rep
            Start-Sleep -Seconds 2
            write "Sleeping for 2 sec.... `n"
        }      
   }
   else
   {
        Write-host "Not a datastore... $vol `n" -ForegroundColor Red
   }

   Start-Sleep -Seconds 3
   write "Sleeping for 3 sec.... `n"
   
}

$VMSReport | Export-Csv NX21AVMS_Datastores.csv -NoTypeInformation -NoClobber


###################################

write "`n`n_____________________________`n`n"
$VMSReportb = @()
$reportb = @()


foreach($vol in $volumelistb){

    if($test = Get-Datastore $vol -ErrorAction silentlycontinue)
    {
        Write-Host "Processing... $vol`n" 

        Get-VM -datastore $vol | foreach {

            $rep = New-Object System.Object 
            $vmname = $_.Name
            $view = get-view -ViewType virtualmachine -Filter @{"Name"=$vmname}
            $cluster = $view.summary.runtime.host | foreach {Get-VMHost -Id $_} | get-cluster
        
            $rep | Add-Member NoteProperty  -Name "Volume/Datastore Name" -Value  $vol
            $rep | Add-Member NoteProperty  -Name "VM Name" -Value  $vmname
            $rep | Add-Member NoteProperty  -Name "VM State" -Value  $view.Runtime.PowerState
            $rep | Add-Member NoteProperty  -Name "Cluster" -Value  $cluster


            $VMSReportb += $rep
            
        }      
   }
   else
   {
        Write-host "Not a datastore... $vol `n" -ForegroundColor Red
   }

   
   
}

$VMSReportb | Export-Csv NX21BVMS_Datastores.csv -NoTypeInformation -NoClobber



