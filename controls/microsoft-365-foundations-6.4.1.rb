control 'microsoft-365-foundations-6.4.1' do
    title 'Ensure mail forwarding rules are reviewed at least weekly'
    desc 'The Exchange Online environment can be configured in a way that allows for automatic forwarding of e-mail. This can be done using Transport Rules in the Admin Center, Auto Forwarding per mailbox, and client-based rules in Outlook. Administrators and users both are given several methods to automatically and quickly send e-mails outside of your organization.'

    desc 'check'
    'To verify mail forwarding rules are being reviewed at least weekly, confirm that the necessary procedures are in place and being followed by the assigned employee.'

    desc 'fix'
    'To review mail forwarding rules:
        1. Navigate to Exchange admin center https://admin.exchange.microsoft.com.
        2. Expand Reports then select Mail flow.
        3. Click on Auto forwarded messages report.
        4. Review.
    Note: Mail flow reports cannot be viewed from the Classic Exchange Admin Center
    To review mail forwarding rules using PowerShell:
        1. Connect to Exchange Online PowerShell using Connect-ExchangeOnline 
            # Uses the administrator user credential to export Mail forwarding rules, User Delegates 
            # and SMTP Forwarding policies to multiple csv files. 
            $allUsers = Get-User -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox" } | Where-Object {$_.AccountDisabled -like "False"} 
            $UserInboxRules = @() 
            $UserDelegates = @() 
            foreach ($User in $allUsers) { 
                Write-Host "Checking inbox rules and delegates for user: " $User.UserPrincipalName $UserInboxRules += Get-InboxRule -Mailbox $User.UserPrincipalName | Select-Object Name, Description, Enabled, Priority, ForwardTo, ForwardAsAttachmentTo, RedirectTo, DeleteMessage | Where-Object { ($_.ForwardTo -ne $null) -or ($_.ForwardAsAttachmentTo -ne $null) -or ($_.RedirectsTo -ne $null) } $UserDelegates += Get-MailboxPermission -Identity $User.UserPrincipalName | Where-Object { ($_.IsInherited -ne "True") -and ($_.User -notlike "*SELF*") } 
            } 
            $SMTPForwarding = Get-Mailbox -ResultSize Unlimited | Select-Object DisplayName, ForwardingAddress, ForwardingSMTPAddress, DeliverToMailboxandForward | Where-Object {$_.ForwardingSMTPAddress -ne $null} 
            # Export list of inbox rules, delegates, and SMTP forwards 
            $UserInboxRules | Export-Csv MailForwardingRulesToExternalDomains.csv -NoTypeInformation 
            $UserDelegates | Export-Csv MailboxDelegatePermissions.csv -NoTypeInformation 
            $SMTPForwarding | Export-Csv Mailboxsmtpforwarding.csv -NoTypeInformation'

    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['8.11'] }, { '7' => ['6.2'] }]

    describe 'manual' do
        skip 'manual'