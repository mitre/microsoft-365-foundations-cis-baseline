control 'microsoft-365-foundations-6.2.2' do
    title 'Ensure mail transport rules do not whitelist specific domains'
    desc 'Mail flow rules (transport rules) in Exchange Online are used to identify and take action on messages that flow through the organization.'

    desc 'check'
    'Ensure mail transport rules do not whitelist specific domains:
        1. Navigate to Exchange admin center https://admin.exchange.microsoft.com..
        2. Click to expand Mail Flow and then select Rules.
        3. Review the rules and verify that none of them whitelist any specific domains.
    To verify that mail transport rules do not whitelist any domains using PowerShell:
        1. Connect to Exchange online using Connect-ExchangeOnline.
        2. Run the following PowerShell command: 
            Get-TransportRule | Where-Object {($_.setscl -eq -1 -and $_.SenderDomainIs -ne $null)} | ft Name,SenderDomainIs'
        
    desc 'fix'
    "To alter the mail transport rules so they do not whitelist any specific domains:
        1. Navigate to Exchange admin center https://admin.exchange.microsoft.com..
        2. Click to expand Mail Flow and then select Rules.
        3. For each rule that whitelists specific domains, select the rule and click the 'Delete' icon.
    To remove mail transport rules using PowerShell:
        1. Connect to Exchange online using Connect-ExchangeOnline.
        2. Run the following PowerShell command: 
            Remove-TransportRule {RuleName}
        3. Verify the rules no longer exists. 
            Get-TransportRule | Where-Object {($_.setscl -eq -1 -and $_.SenderDomainIs -ne $null)} | ft Name,SenderDomainIs"

    impact 0.5
    tag severity: 'medium'

    ref 'https://learn.microsoft.com/en-us/exchange/security-and-compliance/mail-flow-rules/configuration-best-practices'
    ref 'https://learn.microsoft.com/en-us/exchange/security-and-compliance/mail-flow-rules/mail-flow-rules'
end