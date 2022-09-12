# o365-tools

Some scripts for Exchange online and Azure AD routine.

## remove-unlicensed-users-from-DLs.ps1

Removal of all unlicensed o365 accounts from distribution lists with logging. For disable logging just remove *Start-Transcript* and *Stop-Transcript*.

If you need some filters for list of unlicensed users you should edit 8th line adding *-Filter* attribute or *Where-Object* cmdlet.

__This script requires installed MSOnline and Exchange-Online modules.__ 

Find more information below: 

https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-msonlinev1?view=azureadps-1.0 

https://docs.microsoft.com/en-us/powershell/exchange/exchange-online-powershell-v2?view=exchange-ps

If you have other zone domain name then .com., please edit:

1. Line 8: $upn = Get-MsolUser -UnlicensedUsersOnly | Where-Object UserPrincipalName -Match **".com"** | Select-Object UserPrincipalName
