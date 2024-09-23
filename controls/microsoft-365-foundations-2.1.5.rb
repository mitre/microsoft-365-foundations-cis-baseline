control 'microsoft-365-foundations-2.1.5' do
  title 'Ensure Safe Attachments for SharePoint, OneDrive, and Microsoft Teams is Enabled'
  desc 'Safe Attachments for SharePoint, OneDrive, and Microsoft Teams scans these services for malicious files.'

  desc 'check',
       "Ensure Safe Attachments for SharePoint, OneDrive, and Microsoft Teams is Enabled:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com
        2. Under Email & collaboration select Policies & rules
        3. Select Threat policies then Safe Attachments.
        4. Click on Global settings
        5. Ensure the toggle is Enabled to Turn on Defender for Office 365 for SharePoint, OneDrive, and Microsoft Teams.
        6. Ensure the toggle is Enabled to Turn on Safe Documents for Office clients.
        7. Ensure the toggle is Deselected/Disabled to Allow people to click through Protected View even if Safe Documents identified the file as malicious.
    To audit using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Get-AtpPolicyForO365 | fl Name,EnableATPForSPOTeamsODB,EnableSafeDocs,AllowSafeDocsOpen
        Verify the values for each parameter as below:
            EnableATPForSPOTeamsODB : True
            EnableSafeDocs : True
            AllowSafeDocsOpen : False"

  desc 'fix',
       "To enable Safe Attachments for SharePoint, OneDrive, and Microsoft Teams:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com
        2. Under Email & collaboration select Policies & rules
        3. Select Threat policies then Safe Attachments.
        4. Click on Global settings
        5. Click to Enable Turn on Defender for Office 365 for SharePoint, OneDrive, and Microsoft Teams
        6. Click to Enable Turn on Safe Documents for Office clients
        7. Click to Disable Allow people to click through Protected View even if Safe Documents identified the file as malicious.
        8. Click Save
    To remediate using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Set-AtpPolicyForO365 -EnableATPForSPOTeamsODB $true -EnableSafeDocs $true -AllowSafeDocsOpen $false"

  desc 'rationale',
       "Safe Attachments for SharePoint, OneDrive, and Microsoft Teams protect organizations from inadvertently sharing malicious files. When a malicious file is detected that file is blocked so that no one can open, copy, move, or share it until further actions are taken by the organization's security team."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [
    { '8' => ['9.7'] },
    { '8' => ['10.1'] },
    { '7' => ['7.10'] },
    { '7' => ['8.1'] }
  ]
  tag nist: ['SI-3', 'SI-8', 'AU-1', 'AU-2']

  ensure_safe_attachments_for_msproducts_enabled_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    Get-AtpPolicyForO365 | Select-Object Name, EnableATPForSPOTeamsODB, EnableSafeDocs, AllowSafeDocsOpen | ConvertTo-Json
  }

  powershell_output = JSON.parse(powershell(ensure_safe_attachments_for_msproducts_enabled_script).stdout.strip)
  case powershell_output
  when Hash
    describe "Ensure the following Safe Attachment Policy (#{powershell_output['Name']})" do
      it 'should have EnableATPForSPOTeamsODB set to True' do
        expect(powershell_output['EnableATPForSPOTeamsODB']).to eq(true)
      end
      it 'should have EnableSafeDocs set to True' do
        expect(powershell_output['EnableSafeDocs']).to eq(true)
      end
      it 'should have AllowSafeDocsOpen set to False' do
        expect(powershell_output['AllowSafeDocsOpen']).to eq(false)
      end
    end
  when Array
    powershell_output.each do |policy|
      describe %(Ensure the Safe Attachment Policy #{policy['Name']}) do
        it 'should have EnableATPForSPOTeamsODB set to True' do
          expect(powershell_output['EnableATPForSPOTeamsODB']).to eq(true)
        end
        it 'should have EnableSafeDocs set to True' do
          expect(powershell_output['EnableSafeDocs']).to eq(true)
        end
        it 'should have AllowSafeDocsOpen set to False' do
          expect(powershell_output['AllowSafeDocsOpen']).to eq(false)
        end
      end
    end
  end
end
