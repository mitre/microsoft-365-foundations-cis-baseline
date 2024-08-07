control 'microsoft-365-foundations-6.1.1' do
    title "Ensure 'AuditDisabled' organizationally is set to 'False'"
    desc "The value False indicates that mailbox auditing on by default is turned on for the organization. Mailbox auditing on by default in the organization overrides the mailbox auditing settings on individual mailboxes. For example, if mailbox auditing is turned off for a mailbox (the AuditEnabled property on the mailbox is False), the default mailbox actions are still audited for the mailbox, because mailbox auditing on by default is turned on for the organization.
        Turning off mailbox auditing on by default ($true) has the following results:
            • Mailbox auditing is turned off for your organization.
            • From the time you turn off mailbox auditing on by default, no mailbox actions are audited, even if mailbox auditing is enabled on a mailbox (the AuditEnabled property on the mailbox is True).
            • Mailbox auditing isn't turned on for new mailboxes and setting the AuditEnabled property on a new or existing mailbox to True is ignored.
            • Any mailbox audit bypass association settings (configured by using the Set-MailboxAuditBypassAssociation cmdlet) are ignored.
            • Existing mailbox audit records are retained until the audit log age limit for the record expires.
        The recommended state for this setting is False at the organization level. This will enable auditing and enforce the default."
    
    desc 'check'
    'Ensure mailbox auditing is enabled by default at the organizational level:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command: 
            Get-OrganizationConfig | Format-List AuditDisabled
        3. Ensure AuditDisabled is set to False.'
    
    desc 'fix'
    'Enable mailbox auditing at the organizational level:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command: 
            Set-OrganizationConfig -AuditDisabled $false'

    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['8.2'] }, { '7' => ['6.2'] }]

    ref 'https://learn.microsoft.com/en-us/microsoft-365/compliance/audit-mailboxes?view=o365-worldwide'
    ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/set-organizationconfig?view=exchange-ps#-auditdisabled'

    