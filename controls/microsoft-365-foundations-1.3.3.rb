control 'microsoft-365-foundations-1.3.3' do
  title "Ensure 'External sharing' of calendars is not available"
  desc 'External calendar sharing allows an administrator to enable the ability for users to share calendars with anyone outside of the organization. Outside users will be sent a URL that can be used to view the calendar.'

  desc 'check',
       'To audit using the UI:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2. Click to expand Settings select Org settings.
        3. In the Services section click Calendar.
        4. Verify Let your users share their calendars with people outside of your organization who have Office 365 or Exchange is unchecked.
    To audit using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following Exchange Online PowerShell command:
            Get-SharingPolicy -Identity "Default Sharing Policy"
        3. Verify Enabled is set to False'

  desc 'fix',
       'To remediate using the UI:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2. Click to expand Settings select Org settings.
        3. In the Services section click Calendar.
        4. Uncheck Let your users share their calendars with people outside of your organization who have Office 365 or Exchange.
        5. Click Save.
    To remediate using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following Exchange Online PowerShell command:
            Set-SharingPolicy -Identity "Default Sharing Policy" -Enabled $False'

  desc 'rationale',
       'Attackers often spend time learning about organizations before launching an attack. Publicly available calendars can help attackers understand organizational relationships and determine when specific users may be more vulnerable to an attack, such as when they are traveling.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['4.8'] }, { '7' => ['14.6'] }]
  tag nist: ['CM-6', 'CM-7', 'AT-2']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/admin/manage/share-calendars-with-external-users?view=o365-worldwide'

  ensure_external_calendar_sharing_blocked_script = %{
      $client_id = '#{input('client_id')}'
      $certificate_password = '#{input('certificate_password')}'
      $certificate_path = '#{input('certificate_path')}'
      $organization = '#{input('organization')}'
      import-module exchangeonlinemanagement
      Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
      $enabledStatus = Get-SharingPolicy -Identity "Default Sharing Policy" | Select-Object -ExpandProperty Enabled
      Write-Output $enabledStatus
   }

  powershell_output = powershell(ensure_external_calendar_sharing_blocked_script)
  describe 'Ensure the Enabled option for Default Sharing Policy' do
    subject { powershell_output.stdout.strip }
    it 'is set to False' do
      expect(subject).to eq('False')
    end
  end
end
