Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

echo 'Member,DistributionGroup' > '.\desktop\users-distributions.csv'
$users = Get-User | Select-Object -ExpandProperty UserPrincipalName
Foreach ($username in $users) {
    $userDistribs = Get-DistributionGroup | where-object { (Get-DistributionGroupMember $_.Name | foreach {$_.PrimarySmtpAddress}) -contains "$Username"}
    if ($userDistribs) {
        Foreach ($distrib in $userDistribs) {
            $user = $username + ',' + $distrib.DisplayName
            $user >> '.\desktop\users-distributions.csv'
        }
    } else {
        $user = $username + ','
        $user >> '.\desktop\users-distributions.csv'
    }
}
Write-Output 'Done.'

Disconnect-ExchangeOnline