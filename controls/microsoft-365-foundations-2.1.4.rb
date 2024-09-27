control 'microsoft-365-foundations-2.1.4' do
  title '(L2) Ensure Safe Attachments policy is enabled'
  desc 'The Safe Attachments policy helps protect users from malware in email attachments by scanning attachments for viruses, malware, and other malicious content. When an email attachment is received by a user, Safe Attachments will scan the attachment in a secure environment and provide a verdict on whether the attachment is safe or not.'

  desc 'check',
       'Ensure Safe Attachments policy is enabled:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2. Click to expand E-mail & Collaboration select Policies & rules.
        3. On the Policies & rules page select Threat policies.
        4. Under Policies select Safe Attachments.
        5. Inspect the highest priority policy.
        6. Ensure Users and domains and Included recipient domains are in scope for the organization.
        7. Ensure Safe Attachments detection response: is set to Block - Block current and future messages and attachments with detected malware.
        8. Ensure the Quarantine Policy is set to AdminOnlyAccessPolicy.
        9. Ensure the policy is not disabled.
    To verify the Safe Attachments policy is enabled using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Get-SafeAttachmentPolicy | where-object {$_.Enable -eq "True"}'

  desc 'fix',
       "To enable the Safe Attachments policy:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2. Click to expand E-mail & Collaboration select Policies & rules.
        3. On the Policies & rules page select Threat policies.
        4. Under Policies select Safe Attachments.
        5. Click + Create.
        6. Create a Policy Name and Description, and then click Next.
        7. Select all valid domains and click Next.
        8. Select Block.
        9. Quarantine policy is AdminOnlyAccessPolicy.
        10. Leave Enable redirect unchecked.
        11. Click Next and finally Submit."

  desc 'rationale',
       "Enabling Safe Attachments policy helps protect against malware threats in email attachments by analyzing suspicious attachments in a secure, cloud-based environment before they are delivered to the user's inbox. This provides an additional layer of security and can prevent new or unseen types of malware from infiltrating the organization's network."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [
    { '8' => ['9.7'] },
    { '7' => ['7.10'] },
    { '7' => ['8.1'] }
  ]
  tag nist: ['SI-3', 'SI-8', 'AU-1', 'AU-2']

  ensure_safe_attachments_policy_enabled_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    Get-SafeAttachmentPolicy | where-object {$_.Enable -eq "True"}
 }

  powershell_output = powershell(ensure_safe_attachments_policy_enabled_script)
  describe 'Ensure that there is at least one Safe Attachment policy with an Enabled state that' do
    subject { powershell_output.stdout.strip }
    it 'is set to True' do
      expect(subject).not_to be_empty
    end
  end
end
