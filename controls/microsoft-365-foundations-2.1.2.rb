control 'microsoft-365-foundations-2.1.2' do
  title 'Ensure the Common Attachment Types Filter is enabled'
  desc 'The Common Attachment Types Filter lets a user block known and custom malicious file types from being attached to emails.'

  desc 'check',
       "Ensure the Common Attachment Types Filter is enabled:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2. Click to expand Email & collaboration select Policies & rules.
        3. On the Policies & rules page select Threat policies.
        4. Under polices select Anti-malware and click on the Default (Default) policy.
        5. On the policy page that appears on the righthand pane, under Protection settings, verify that the Enable the common attachments filter has the value of On.
    To verify the Common Attachment Types Filter is enabled using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following Exchange Online PowerShell command:
            Get-MalwareFilterPolicy -Identity Default | Select-Object EnableFileFilter
        3. Verify EnableFileFilter is set to True.
    NOTE: Audit and Remediation guidance may focus on the Default policy however, if a Custom Policy exists in the organization's tenant then ensure the setting is set as outlined in the highest priority policy listed."

  desc 'fix',
       "To enable the Common Attachment Types Filter:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2. Click to expand Email & collaboration select Policies & rules.
        3. On the Policies & rules page select Threat policies.
        4. Under polices select Anti-malware and click on the Default (Default) policy.
        5. On the Policy page that appears on the right hand pane scroll to the bottom and click on Edit protection settings, check the Enable the common attachments filter.
        6. Click Save.
    To enable the Common Attachment Types Filter using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following Exchange Online PowerShell command: Set-MalwareFilterPolicy -Identity Default -EnableFileFilter $true
    NOTE: Audit and Remediation guidance may focus on the Default policy however, if a Custom Policy exists in the organization's tenant then ensure the setting is set as outlined in the highest priority policy listed."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['9.6'] }, { '7' => ['7.9'] }, { '7' => ['8.1'] }]

  ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/get-malwarefilterpolicy?view=exchange-ps'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/anti-malware-policies-configure?view=o365-worldwide'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
