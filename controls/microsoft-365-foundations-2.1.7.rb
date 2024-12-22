control 'microsoft-365-foundations-2.1.7' do
  title 'Ensure that an anti-phishing policy has been created'
  desc 'By default, Office 365 includes built-in features that help protect users from phishing attacks. Set up anti-phishing polices to increase this protection, for example by refining settings to better detect and prevent impersonation and spoofing attacks. The default policy applies to all users within the organization and is a single view to fine-tune anti-phishing protection. Custom policies can be created and configured for specific users, groups or domains within the organization and will take precedence over the default policy for the scoped users.'

  desc 'check',
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

  desc 'fix',
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

  desc 'rationale',
       'Protects users from phishing attacks (like impersonation and spoofing), and uses safety tips to warn users about potentially harmful messages.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['9.7'] }, { '7' => ['7'] }]
  tag nist: ['SI-3', 'SI-8']

  ensure_anti_phishing_policy_created_script = %{
    $policies = Get-AntiPhishPolicy | Select-Object Name, Enabled, PhishThresholdLevel, EnableMailboxIntelligenceProtection, EnableMailboxIntelligence, EnableSpoofIntelligence

    foreach ($policy in $policies) {
        $failedConditions = @()

        if ($policy.Enabled -eq $false) {
            $failedConditions += "Enabled"
        }
        if ($policy.PhishThresholdLevel -lt 2) {
            $failedConditions += "PhishThresholdLevel"
        }
        if ($policy.EnableMailboxIntelligenceProtection -eq $false) {
            $failedConditions += "EnableMailboxIntelligenceProtection"
        }
        if ($policy.EnableMailboxIntelligence -eq $false) {
            $failedConditions += "EnableMailboxIntelligence"
        }
        if ($policy.EnableSpoofIntelligence -eq $false) {
            $failedConditions += "EnableSpoofIntelligence"
        }

        if ($failedConditions.Count -gt 0) {
            Write-Output "Policy Name: $($policy.Name), Failed Conditions = [$($failedConditions -join ', ')]"
        }
    }
  }
  powershell_output = pwsh_single_session_executor(ensure_anti_phishing_policy_created_script).run_script_in_graph_exchange

  describe 'Ensure the number of anti-phishing policies that have the settings Enabled as False, PhishThresholdLevel < 2, EnableMailboxIntelligenceProtection as False, EnableMailboxIntelligence as False, or EnableSpoofIntelligence as False' do
    subject { powershell_output.stdout.strip }
    it 'is 0' do
      failure_message = "The following anti-phishing policies have failed along with the conditions they have failed on: #{powershell_output.stdout.strip.split("\n").join(',')}"
      expect(subject).to be_empty, failure_message
    end
  end
end
