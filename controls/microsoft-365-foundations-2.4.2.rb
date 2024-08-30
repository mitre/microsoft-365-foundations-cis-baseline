control 'microsoft-365-foundations-2.4.2' do
  title "Ensure Priority accounts have 'Strict protection' presets applied"
  desc "Preset security policies have been established by Microsoft, utilizing observations and experiences within datacenters to strike a balance between the exclusion of malicious content from users and limiting unwarranted disruptions. These policies can apply to all, or select users and encompass recommendations for addressing spam, malware, and phishing threats. The policy parameters are pre-determined and non-adjustable.
        Strict protection has the most aggressive protection of the 3 presets.
            •EOP: Anti-spam, Anti-malware and Anti-phishing
            •Defender: Spoof protection, Impersonation protection and Advanced phishing
            •Defender: Safe Links and Safe Attachments
        NOTE: The preset security polices cannot target Priority account TAGS currently, groups should be used instead."

  desc 'check',
       "Verify strict preset security policies have been applied to Priority accounts:
        1.Navigate to Microsoft 365 Defender https://security.microsoft.com/
        2.Select to expand E-mail & collaboration.
        3.Select Policies & rules > Threat policies.
        4.From here visit each section in turn: Anti-phishing Anti-spam Anti-malware Safe Attachments Safe Links
        5.Ensure in each there is a policy named Strict Preset Security Policy which includes the organization's priority Accounts/Groups."

  desc 'fix',
       "Enable strict preset security policies for Priority accounts:
        1.Navigate to Microsoft 365 Defender https://security.microsoft.com/
        2.Select to expand E-mail & collaboration.
        3.Select Policies & rules > Threat policies > Preset security policies.
        4.Click to Manage protection settings for Strict protection preset.
        5.For Apply Exchange Online Protection select at minimum Specific recipients and include the Accounts/Groups identified as Priority Accounts.
        6.For Apply Defender for Office 365 Protection select at minimum Specific recipients and include the Accounts/Groups identified as Priority Accounts.
        7.For Impersonation protection click Next and add valid e-mails or priority accounts both internal and external that may be subject to impersonation.
        8.For Protected custom domains add the organization's domain name, along side other key partners.
        9.Click Next and finally Confirm"

  desc 'rationale',
       'Enabling priority account protection for users in Microsoft 365 is necessary to enhance
        security for accounts with access to sensitive data and high privileges, such as CEOs,
        CISOs, CFOs, and IT admins. These priority accounts are often targeted by spear
        phishing or whaling attacks and require stronger protection to prevent account
        compromise.
        The implementation of stringent, pre-defined policies may result in instances of false
        positive, however, the benefit of requiring the end-user to preview junk email before
        accessing their inbox outweighs the potential risk of mistakenly perceiving a malicious
        email as safe due to its placement in the inbox.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['9.7'] }, { '8' => ['10.7'] }]
  tag default_value: 'By default, presets are not applied to any users or groups.'
  tag nist: ['SI-3', 'SI-8', 'SI-4']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/preset-security-policies?view=o365-worldwide'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/security-recommendations-for-priority-accounts'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/recommended-settings-for-eop-and-office365?view=o365-worldwide#impersonation-settings-in-anti-phishing-policies-in-microsoft-defender-for-office-365'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
