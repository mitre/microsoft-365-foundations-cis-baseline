control 'microsoft-365-foundations-2.1.11' do
    title 'Ensure the spoofed domains report is reviewed weekly'
    desc 'Use spoof intelligence in the Security Center on the Anti-spam settings page to review all senders who are spoofing either domains that are part of the organization or spoofing external domains. Spoof intelligence is available as part of Office 365 Enterprise E5 or separately as part of Defender for Office 365 and as of October 2018 Exchange Online Protection (EOP).'

    desc 'check'
    'To verify the report is being reviewed at least weekly, confirm that the necessary procedures are in place and being followed.'

    desc 'fix'
    'To review the spoofed domains report:
        1.Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2.Under Email & collaboration click on Policies & rules then select Threat policies.
        3.Under Rules click on Tenant Allow / Block Lists then select Spoofed senders.
        4.Review.
    To view spoofed senders that were allowed or blocked by spoof intelligence in the last 7 days:
        1.Connect to Exchange Online using Connect-ExchangeOnline.
        2.Run the following PowerShell command: 
            Get-SpoofIntelligenceInsight
        3.Review.'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['8.11'] }, {'7' => ['6.2']}]  

    ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/anti-spoofing-spoof-intelligence?view=o365-worldwide'
    ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/get-spoofintelligenceinsight?view=exchange-ps'

    describe 'manual' do
        skip 'manual'