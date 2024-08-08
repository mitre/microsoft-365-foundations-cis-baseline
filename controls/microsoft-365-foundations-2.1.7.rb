control 'microsoft-365-foundations-2.1.7' do 
    title 'Ensure that an anti-phishing policy has been created'
    desc 'By default, Office 365 includes built-in features that help protect users from phishing attacks. Set up anti-phishing polices to increase this protection, for example by refining settings to better detect and prevent impersonation and spoofing attacks. The default policy applies to all users within the organization and is a single view to fine-tune anti-phishing protection. Custom policies can be created and configured for specific users, groups or domains within the organization and will take precedence over the default policy for the scoped users.'

    desc 'check'
    "Note: Audit and Remediation guidance may focus on the Default policy however, if a Custom Policy exists in the organization's tenant then ensure the setting is set as outlined in the highest priority policy listed.
    Ensure that an anti-phishing policy has been created:
        1.Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2.Click to expand Email & collaboration select Policies & rules
        3.Select Threat policies.
        4.Under Policies select Anti-phishing.
        5.Verify the Office365 AntiPhish Default (Default) policy exists and is Always on.
        6.Verify that Phishing email threshold is set to at least 2 - Aggressive
        7.Verify the following features are enabled: Mailbox intelligence - Mailbox intelligence for impersonations and Spoof intelligence.
    To verify the anti-phishing policy using PowerShell:
        1.Connect to Exchange Online service using Connect-ExchangeOnline.
        2.Run the following Exchange Online PowerShell command: Get-AntiPhishPolicy | Format-Table -AutoSize ` name, enabled, PhishThresholdLevel, ` EnableMailboxIntelligenceProtection, ` EnableMailboxIntelligence, EnableSpoofIntelligence
        3.Verify values for Office365 AntiPhish Default and custom policies are:
            •Enabled - True
            •PhishThresholdLevel - at least 2
            •EnableMailboxIntelligenceProtection - True
            •EnableMailboxIntelligence - True
            •EnableSpoofIntelligence - True"
    
    desc 'fix'
    "Note: Audit and Remediation guidance may focus on the Default policy however, if a Custom Policy exists in the organization's tenant then ensure the setting is set as outlined in the highest priority policy listed. To set the anti-phishing policy
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2. Click to expand Email & collaboration select Policies & rules
        3. Select Threat policies.
        4. Under Policies select Anti-phishing.
        5. Select the Office365 AntiPhish Default (Default) policy and click Edit protection settings.
        6. Set the Phishing email threshold to at least 2 - Aggressive.
    Under Impersonation
        • Check Enable mailbox intelligence (Recommended)
        • Check Enable Intelligence for impersonation protection (Recommended).
    Under Spoof
        • Check Enable spoof intelligence (Recommended).
        7. Click Save.
    To create an anti-phishing policy using PowerShell:
        1. Connect to Exchange Online service using Connect-ExchangeOnline.
        2. Run the following Exchange Online PowerShell command:
            New-AntiPhishPolicy -Name \"Office365 AntiPhish Policy\""
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['9.7'] }, {'7' => ['7']}]        
end
