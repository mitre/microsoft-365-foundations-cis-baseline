control 'microsoft-365-foundations-6.1.2' do
  title 'Ensure mailbox auditing for E3 users is Enabled'
  desc "Mailbox audit logging is turned on by default in all organizations. This effort started in January 2019, and means that certain actions performed by mailbox owners, delegates, and admins are automatically logged. The corresponding mailbox audit records are available for admins to search in the mailbox audit log.
        Mailboxes and shared mailboxes have actions assigned to them individually in order to audit the data the organization determines valuable at the mailbox level.
        The recommended state is AuditEnabled to True on all user mailboxes along with additional audit actions beyond the Microsoft defaults.
        Note: Due to some differences in defaults for audit actions this recommendation is specific to users assigned an E3 license only."

  desc 'check',
       'To manually verify mailbox auditing is enabled and configured for all mailboxes:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell script:
            $MailAudit = Get-EXOMailbox -PropertySets Audit -ResultSize Unlimited | Select-Object UserPrincipalName, AuditEnabled, AuditAdmin, AuditDelegate, AuditOwner
            $MailAudit | Export-Csv -Path C:\CIS\AuditSettings.csv -NoTypeInformation
        3. Analyze the output and verify AuditEnabled is set to True and all audit actions are included in what is defined in the script in the remediation section.
    Optionally, this more comprehensive script can assess each user mailbox:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following script:

            $AdminActions = @( "ApplyRecord", "Copy", "Create", "FolderBind", "HardDelete", "Move", "MoveToDeletedItems", "SendAs", "SendOnBehalf", "SoftDelete", "Update", "UpdateCalendarDelegation", "UpdateFolderPermissions", "UpdateInboxRules"
            )
            DelegateActions = @( "ApplyRecord", "Create", "FolderBind", "HardDelete", "Move", "MoveToDeletedItems", "SendAs", "SendOnBehalf", "SoftDelete", "Update", "UpdateFolderPermissions", "UpdateInboxRules"
            )
            $OwnerActions = @( "ApplyRecord", "Create", "HardDelete", "MailboxLogin", "Move", "MoveToDeletedItems", "SoftDelete", "Update", "UpdateCalendarDelegation", "UpdateFolderPermissions", "UpdateInboxRules"
            )
            function VerifyActions {
                param ( [string]$type, [array]$actions, [array]$auditProperty, [string]$mailboxName
                )
                $missingActions = @()
                $actionCount = 0
                foreach ($action in $actions) {
                    if ($auditProperty -notcontains $action) {
                        $missingActions += " Failure: Audit action \'$action\' missing from $type"
                        $actionCount++
                    }
                }
                if ($actionCount -eq 0) {
                    Write-Host "[$mailboxName]: $type actions are verified." -ForegroundColor Green
                }
                else {
                    Write-Host "[$mailboxName]: $type actions are not all verified." -ForegroundColor Red
                    foreach ($missingAction in $missingActions) {
                        Write-Host " $missingAction" -ForegroundColor Red
                    }
                }
            }
            $mailboxes = Get-EXOMailbox -PropertySets Audit,Minimum -ResultSize Unlimited | Where-Object { $_.RecipientTypeDetails -eq "UserMailbox" }
            foreach ($mailbox in $mailboxes) {
                Write-Host "--- Now assessing [$($mailbox.UserPrincipalName)] ---"
                if ($mailbox.AuditEnabled) {
                    Write-Host "[$($mailbox.UserPrincipalName)]: AuditEnabled is true" -ForegroundColor Green
                }
                else {
                    Write-Host "[$($mailbox.UserPrincipalName)]: AuditEnabled is false" -ForegroundColor Red
                }
                VerifyActions -type "AuditAdmin" -actions $AdminActions -auditProperty $mailbox.AuditAdmin ` -mailboxName $mailbox.UserPrincipalName
                VerifyActions -type "AuditDelegate" -actions $DelegateActions -auditProperty $mailbox.AuditDelegate ` -mailboxName $mailbox.UserPrincipalName
                VerifyActions -type "AuditOwner" -actions $OwnerActions -auditProperty $mailbox.AuditOwner ` -mailboxName $mailbox.UserPrincipalName
                Write-Host
            }'
  desc 'fix',
       'To enable mailbox auditing for all user mailboxes using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell script:
            $AuditAdmin = @( "ApplyRecord", "Copy", "Create", "FolderBind", "HardDelete", "Move", "MoveToDeletedItems", "SendAs", "SendOnBehalf", "SoftDelete", "Update", "UpdateCalendarDelegation", "UpdateFolderPermissions", "UpdateInboxRules" )
            $AuditDelegate = @( "ApplyRecord", "Create", "FolderBind", "HardDelete", "Move", "MoveToDeletedItems", "SendAs", "SendOnBehalf", "SoftDelete", "Update", "UpdateFolderPermissions", "UpdateInboxRules" )
            $AuditOwner = @( "ApplyRecord", "Create", "HardDelete", "MailboxLogin", "Move", "MoveToDeletedItems", "SoftDelete", "Update", "UpdateCalendarDelegation", "UpdateFolderPermissions", "UpdateInboxRules" )
            $MBX = Get-EXOMailbox -ResultSize Unlimited | Where-Object { $_.RecipientTypeDetails -eq "UserMailbox" }
            $MBX | Set-Mailbox -AuditEnabled $true ` -AuditLogAgeLimit 90 -AuditAdmin $AuditAdmin -AuditDelegate $AuditDelegate ` -AuditOwner $AuditOwner'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['8.2'] }, { '7' => ['6.2'] }]

  ref 'https://learn.microsoft.com/en-us/microsoft-365/compliance/audit-mailboxes?view=o365-worldwide'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
