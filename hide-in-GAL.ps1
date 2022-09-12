Import-Module ExchangeOnline
Connect-ExchangeOnline

$confirmation = 'n'
$types = @('Enter user manually', 'From imported CSV','All shared mailboxes')
do {
    $SelectFrom =  $types | Out-GridView -Title 'Choose a list of users source' -OutputMode Single
    if ($SelectFrom -eq 'All shared mailboxes') {
        $SMList = Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize:Unlimited | Select-Object UserPrincipalName
    } elseif ($SelectFrom -eq 'From imported CSV (header should be UserPrincipalName)') {
        $csv = Read-Host 'Enter .csv path '
        $SMList = Import-Csv $csv | Select-Object -ExpandProperty UserPrincipalName
    } else {
        $SMList = Read-Host 'Enter email to hide in GAL '
        $manually = 1
    }
    Write-Host $SMList | Select-Object -ExpandProperty UserPrincipalName | ft
    $confirmation = Read-Host 'Please confirm the list of users to remove from GAL (y/n) '
} while ($confirmation -match 'n')

if ($manually -eq 1) {
    Set-Mailbox -Identity $SMList -HiddenFromAddressListsEnabled $true
    break
}

foreach ($SM in $SMList) {
    Set-Mailbox -Identity $SM.UserPrincipalName -HiddenFromAddressListsEnabled $true
}

Disconnect-ExchangeOnline