control 'microsoft-365-foundations-6.1.4' do
    title "Ensure 'AuditBypassEnabled' is not enabled on mailboxes"
    desc 'When configuring a user or computer account to bypass mailbox audit logging, the system will not record any access, or actions performed by the said user or computer account on any mailbox. Administratively this was introduced to reduce the volume of entries in the mailbox audit logs on trusted user or computer accounts.
        Ensure AuditBypassEnabled is not enabled on accounts without a written exception.'
    
    desc 'check'
    'Ensure Audit Bypass is not enabled using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command: 
            $MBX = Get-MailboxAuditBypassAssociation -ResultSize unlimited 
            $MBX | where {$_.AuditBypassEnabled -eq $true} | Format-Table Name,AuditBypassEnabled
        3. If nothing is returned, then there are no accounts with Audit Bypass enabled.'
    
    desc 'fix'
    'Disable Audit Bypass on all mailboxes using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. The following example PowerShell script will disable AuditBypass for all mailboxes which currently have it enabled: 

            # Get mailboxes with AuditBypassEnabled set to $true 
            $MBXAudit = Get-MailboxAuditBypassAssociation -ResultSize unlimited | Where-Object { $_.AuditBypassEnabled -eq $true } 
            foreach ($mailbox in $MBXAudit) { 
                $mailboxName = $mailbox.Name 
                Set-MailboxAuditBypassAssociation -Identity $mailboxName -AuditBypassEnabled $false 
                Write-Host "Audit Bypass disabled for mailbox Identity: $mailboxName" -ForegroundColor Green 
            }'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['8.5'] }]

    ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/get-mailboxauditbypassassociation?view=exchange-ps'

    describe 'manual' do
        skip 'manual'
    end
end