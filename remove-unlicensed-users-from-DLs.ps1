Connect-ExchangeOnline
Connect-MsolService

#start logging
Start-Transcript -Path '.\desktop\distribution-removal.log'

#get users list
$upn = Get-MsolUser -UnlicensedUsersOnly | Where-Object UserPrincipalName -Match ".com" | Select-Object UserPrincipalName

Write-Host 'Unlicensed users: '
Write-Output ($upn | select -expand *)

# process all of the unlicensed mailboxes individually
foreach ($Mailbox in $upn) {

    # get list of all distribution groups for the mailbox
	$DistributionGroupsList = Get-DistributionGroup | where { (Get-DistributionGroupMember $_.PrimarySmtpAddress | Select-Object -ExpandProperty WindowsLiveID) -contains $Mailbox.UserPrincipalName}

    # check if there are any distributions, if there are not process next mailbox
    if ($DistributionGroupsList) {

        # process distributions for the mailbox individually
        ForEach ($item in $DistributionGroupsList) {
            Write-Host 'Processing removal of ' $mailbox.UserPrincipalName ' from ' $item.DisplayName ' distribution list'
            # error handling:
            # try to remove
            # if there is error, write error to the log file
            # anyways check if mailbox removed from distribution and write result to the log file
            Try { # REMOVE FROM DISTRIBUTION
                Remove-DistributionGroupMember -Identity $item.DisplayName –Member $mailbox.UserPrincipalName -Confirm:$False
            } Catch { # CATCH LAST ERROR IF TRY NOT CORRECTLY COMPLETE
                Write-Host 'An error occurred'
                Write-Host $error[0]
            } Finally { # DO ANYWAY
                If (Get-DistributionGroupMember -Identity $item.DisplayName | Where-Object {$_.PrimarySmtpAddress -match $mailbox.UserPrincipalName}) {
                    Write-Host 'RESULT: ' $mailbox.UserPrincipalName ' is still in the ' $item.DisplayName ' distribution list. Please, remove it manually.'
                } else {
                    Write-Host 'RESULT: ' $mailbox.UserPrincipalName ' is no longer ' $item.DisplayName ' distribution list. REMOVAL COMPLETE SUCCESSFULLY.'
                }
            }   
        }
        
    } else {
        Write-Host 'There are no any distribution lists for user ' $mailbox.UserPrincipalName
    }

}

Stop-Transcript

Disconnect-ExchangeOnline

Pause