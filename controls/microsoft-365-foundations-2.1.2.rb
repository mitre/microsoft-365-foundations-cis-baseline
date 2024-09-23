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

  desc 'rationale',
       'Blocking known malicious file types can help prevent malware-infested files from infecting a host.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['9.6'] }, { '7' => ['7.9'] }, { '7' => ['8.1'] }]
  tag default_value: 'Always on'
  tag nist: ['SI-3', 'SI-8', 'AU-1', 'AU-2', '']

  ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/get-malwarefilterpolicy?view=exchange-ps'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/anti-malware-policies-configure?view=o365-worldwide'

  ensure_common_attachment_types_filter_enabled_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    Get-MalwareFilterPolicy -Identity Default | Select-Object -ExpandProperty EnableFileFilter
 }

  powershell_output = powershell(ensure_common_attachment_types_filter_enabled_script)
  describe 'Ensure the EnableFileFilter option from Get-MalwareFilterPolicy' do
    subject { powershell_output.stdout.strip }
    it 'is set to True' do
      expect(subject).to eq('True')
    end
  end
end
