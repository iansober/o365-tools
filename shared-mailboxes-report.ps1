Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize:Unlimited | Get-MailboxPermission | Select-Object Identity,User,AccessRights | Where-Object {($_.user -like '*@*')} | Export-Csv -Path '.\desktop\shared-mailboxes.csv'
Write-Output 'Done.'

Disconnect-ExchangeOnline