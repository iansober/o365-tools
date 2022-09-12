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

## hide-in-GAL.ps1

Tool for removing accounts from Global Address List.

You can just remove all shared mailboxes from GAL or specific accounts you entered manually or with .csv file.

**CSV should have UserPrincipalName header.**

## DLs-members-report.ps1

Reports about all distribution groups and members of them.

It gets distribution groups first and then starts to get all members of them. You will see the data as a table in CSV with the columns: DitributionGroup, Member (usernames) and Type.
