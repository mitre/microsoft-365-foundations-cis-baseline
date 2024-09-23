control 'microsoft-365-foundations-6.2.3' do
  title 'Ensure email from external senders is identified'
  desc %q(External callouts provide a native experience to identify emails from senders outside the organization. This is achieved by presenting a new tag on emails called "External" (the string is localized based on the client language setting) and exposing related user interface at the top of the message reading view to see and verify the real sender's email address.
        Once this feature is enabled via PowerShell, it might take 24-48 hours for users to start seeing the External sender tag in email messages received from external sources (outside of your organization), providing their Outlook version supports it.
        The recommended state is ExternalInOutlook set to Enabled True
        Note: Mail flow rules are often used by Exchange administrators to accomplish the External email tagging by appending a tag to the front of a subject line. There are limitations to this outlined here. The preferred method in the CIS Benchmark is to use the native experience.)

  desc 'check',
       "To verify external sender tagging using PowerShell:
        1. Connect to Exchange online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Get-ExternalInOutlook
        3. For each identity verify Enabled is set to True and the AllowList only contains email addresses the organization has permitted to bypass external tagging."

  desc 'fix',
       "To enable external tagging using PowerShell:
        1. Connect to Exchange online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Set-ExternalInOutlook -Enabled $true"

  desc 'rationale',
       "Tagging emails from external senders helps to inform end users about the origin of the
        email. This can allow them to proceed with more caution and make informed decisions
        when it comes to identifying spam or phishing emails.
        Note: Existing emails in a user's inbox from external senders are not tagged
        retroactively."

  impact 0.5
  tag severity: 'medium'
  tag default_value: 'Disabled (False)'
  tag cis_controls: [{ '8' => ['untracked'] }, { '7' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://techcommunity.microsoft.com/t5/exchange-team-blog/native-external-sender-callouts-on-email-in-outlook/ba-p/2250098'
  ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/set-externalinoutlook?view=exchange-ps'

  permitted_emails = input('email_addresses_bypass_external_tagging')
  email_pattern = permitted_emails.map { |email| "'#{email}'" }.join(', ')
  ensure_email_from_external_senders_identified_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    $allowedEmails = @(#{email_pattern})
    $object = Get-ExternalInOutlook
    $object | Where-Object {
      $_.Enabled -eq $false -or
      ($_.AllowList | ForEach-Object { $allowedEmails -contains $_ } | Where-Object { $_ -eq $false } | Measure-Object).Count -gt 0
   } | Select-Object -ExpandProperty Identity
  }
  powershell_output = powershell(ensure_email_from_external_senders_identified_script).stdout.strip
  error_identities = powershell_output.split("\n") unless powershell_output.empty?
  describe 'Ensure the number of identities with Enabled state as False and AllowedList with non-permitted email addresses' do
    subject { powershell_output }
    it 'is 0' do
      failure_message = "Identities breaking the rules: #{error_identities}"
      expect(subject).to be_empty, failure_message
    end
  end
end
