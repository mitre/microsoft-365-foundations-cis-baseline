control 'microsoft-365-foundations-2.4.4' do
    title 'Ensure Zero-hour auto purge for Microsoft Teams is on'
    desc 'Zero-hour auto purge (ZAP) is a protection feature that retroactively detects and neutralizes malware and high confidence phishing. When ZAP for Teams protection blocks a message, the message is blocked for everyone in the chat. The initial block happens right after delivery, but ZAP occurs up to 48 hours after delivery.'

    desc 'check'
    'To audit using the UI:
        1.Navigate to Microsoft Defender https://security.microsoft.com/
        2.Click Settings > Email & collaboration > Microsoft Teams protection.
        3.Ensure Zero-hour auto purge (ZAP) is set to On (Default)
        4.Under Exclude these participants review the list of exclusions and ensure they are justified and within tolerance for the organization.
    To audit using PowerShell:
        1.Connect to Exchange Online using Connect-ExchangeOnline.
        2.Run the following cmdlets: 
            Get-TeamsProtectionPolicy | fl ZapEnabled 
            Get-TeamsProtectionPolicyRule | fl ExceptIf*
        3.Ensure ZapEnabled is True.
        4.Review the list of exclusions and ensure they are justified and within tolerance for the organization. If nothing returns from the 2nd cmdlet then there are no exclusions defined.'

    desc 'fix'
    'To remediate using the UI:
        1.Navigate to Microsoft Defender https://security.microsoft.com/
        2.Click Settings > Email & collaboration > Microsoft Teams protection.
        3.Set Zero-hour auto purge (ZAP) to On (Default)
    To remediate using PowerShell:
        1.Connect to Exchange Online using Connect-ExchangeOnline.
        2.Run the following cmdlet: 
            Set-TeamsProtectionPolicy -Identity "Teams Protection Policy" -ZapEnabled $true'

    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['10.1'] }]
    
    ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/zero-hour-auto-purge?view=o365-worldwide#zero-hour-auto-purge-zap-in-microsoft-teams'
    ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/mdo-support-teams-about?view=o365-worldwide#configure-zap-for-teams-protection-in-defender-for-office-365-plan-2'
end