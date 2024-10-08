control 'microsoft-365-foundations-6.5.3' do
  title 'Ensure additional storage providers are restricted in Outlook on the web'
  desc "This setting allows users to open certain external files while working in Outlook on the web. If allowed, keep in mind that Microsoft doesn't control the use terms or privacy policies of those third-party services.
        Ensure AdditionalStorageProvidersAvailable are restricted."

  desc 'check',
       "To audit using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Get-OwaMailboxPolicy | Format-Table Name, AdditionalStorageProvidersAvailable
        3. Verify that the value returned is False."

  desc 'fix',
       "To remediate using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Set-OwaMailboxPolicy -Identity OwaMailboxPolicy-Default -AdditionalStorageProvidersAvailable $false"

  desc 'rationale',
       'By default additional storage providers are allowed in Office on the Web (such as Box,
        Dropbox, Facebook, Google Drive, OneDrive Personal, etc.). This could lead to
        information leakage and additional risk of infection from organizational non-trusted
        storage providers. Restricting this will inherently reduce risk as it will narrow
        opportunities for infection and data leakage.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [
    { '8' => ['3.3'] },
    { '7' => ['13.1'] },
    { '7' => ['13.4'] }
  ]
  tag nist: ['AC-3', 'AC-5', 'AC-6', 'MP-2', 'AU-6(1)', 'AU-7', 'IR-4(1)', 'SI-4(2)', 'SI-4(5)', 'CA-9', 'SC-7']

  ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/set-owamailboxpolicy?view=exchange-ps'
  ref 'https://support.microsoft.com/en-us/topic/3rd-party-cloud-storage-services-supported-by-office-apps-fce12782-eccc-4cf5-8f4b-d1ebec513f72'

  ensure_additional_storage_providers_restricted_web_outlook_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    (Get-OwaMailboxPolicy).AdditionalStorageProvidersAvailable
 }

  powershell_output = powershell(ensure_additional_storage_providers_restricted_web_outlook_script)
  describe 'Ensure the AdditionalStorageProvidersAvailable option from Get-OwaMailboxPolicy' do
    subject { powershell_output.stdout.strip }
    it 'is set to False' do
      expect(subject).to eq('False')
    end
  end
end
