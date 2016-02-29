

$report = @()

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
 $current = 1
foreach($vol in $volumelist){
    $volumeinfo = New-Object System.Object    
    $vmcount = $null
    $IsDS = $null
    $cluster =  $null
    $note = $null
    Write-host "Processing $($volumelist.Count) / $current `n" -ForegroundColor Green
    if(get-datastore $vol -ErrorAction SilentlyContinue)
    {
        Write-host "$vol is a datastore...`n"
        $note = "There is a DataStore associated with the NFS export"
        $vms = Get-VM -Datastore $vol
        $clusters = 0
        
        $vmcount = ($vms | measure).Count
        $IsDS = "Yes"


        #$dsview = Get-Datastore $vol | get-view 
        [string]$cluster =  Get-Datastore $vol  | Get-VMHost | Get-Cluster
        
        $volumeinfo | Add-Member NoteProperty  -Name "Volume Name" -Value  $vol
        $volumeinfo | Add-Member NoteProperty  -Name "Is Datastore" -Value  $IsDS
        $volumeinfo | Add-Member NoteProperty  -Name "Cluster" -Value  $cluster
        $volumeinfo | Add-Member NoteProperty  -Name "VM Count" -Value  $vmcount
        $volumeinfo | Add-Member NoteProperty  -Name "Note" -Value  $Note   
    }
    else
    {
         Write-host  "$vol is not a datastore...`n" -ForegroundColor Red

        $note = "NO Associated Datastore"
        $IsDS = "NO"

        $volumeinfo | Add-Member NoteProperty  -Name "Volume Name" -Value  $vol
        $volumeinfo | Add-Member NoteProperty  -Name "Is Datastore" -Value  $IsDS
        $volumeinfo | Add-Member NoteProperty  -Name "Cluster" -Value  "N/A"
        $volumeinfo | Add-Member NoteProperty  -Name "VM Count" -Value  "0"
        $volumeinfo | Add-Member NoteProperty  -Name "Note" -Value  $Note
    }
    $current++
    $report += $volumeinfo
}
$report | Export-Csv VolumeInfo.CSV -NoTypeInformation -NoClobber


