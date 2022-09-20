Import-Module ExchangeOnlineManagement
Import-Module AzureAD

$CsvPath = Read-Host 'Enter full csv path (csv must have Address header): '
$DistributionGroups = Import-Csv $CsvPath

Connect-ExchangeOnline
Connect-AzureAD

$Report = Foreach ($DistributionGroup in $DistributionGroups) {
    Get-DistributionGroupMember -Identity $DistributionGroup.Address | Select-Object @{Name='DistributionGroup';Expression={$DistributionGroup.Address}}, WindowsLiveID, DisplayName, @{Name='AccountEnabled';Expression={Get-AzureADUser -SearchString $_.WindowsLiveID | Select-Object -ExpandProperty AccountEnabled}}
} 

$Report | Export-Csv DG-Report.csv

Write-Output $Error > DG-Report-Errors.log

Disconnect-ExchangeOnline
Disconnect-AzureAD
