Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

$distribList = Get-DistributionGroup
echo 'DistributionGroup,Member,Type' > '.\desktop\distribution-lists.csv'
Foreach ($distribGroup in $distribList) {
    $distribGroupMember = Get-DistributionGroupMember -Identity $distribGroup.Name
    Foreach ($member in $distribGroupMember) {
        $distribMember = $distribGroup.DisplayName + ',' + $member.Name + ',' + $member.RecipientType
        $distribMember >> '.\desktop\distribution-lists.csv'
    }
}
$users = Get-User | Select-Object Identity
$reference = Import-Csv '.\desktop\distribution-lists.csv' | Select-Object Member
Foreach ($user in $users) {
    $select = $reference | Where-Object {$_.Member -eq $user.Identity}
    if (!($select)) {
        $adduser = ',' + $user.Identity + ','
        $adduser >> '.\desktop\distribution-lists.csv'
    }
}
Write-Output 'Done.'

Disconnect-ExchangeOnline