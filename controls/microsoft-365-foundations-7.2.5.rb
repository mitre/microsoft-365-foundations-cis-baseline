control 'microsoft-365-foundations-7.2.5' do
  title "Ensure that SharePoint guest users cannot share items they don't own"
  desc 'SharePoint gives users the ability to share files, folders, and site collections. Internal users can share with external collaborators, and with the right permissions could share to other external parties.'

  desc 'check',
       "To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies then select Sharing.
        3. Expand More external sharing settings, verify that Allow guests to share items they don't own is unchecked.
    To audit using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following SharePoint Online PowerShell command:
            Get-SPOTenant | ft PreventExternalUsersFromResharing
        3. Ensure the returned value is True."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies then select Sharing.
        3. Expand More external sharing settings, uncheck Allow guests to share items they don't own.
        4. Click Save.
    To remediate using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following SharePoint Online PowerShell command:
            Set-SPOTenant -PreventExternalUsersFromResharing $True"

  desc 'rationale',
       'Sharing and collaboration are key; however, file, folder, or site collection owners should
        have the authority over what external users get shared with to prevent unauthorized
        disclosures of information.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['3.3'] }, { '7' => ['14.6'] }]
  tag nist: ['AC-3', 'AC-5', 'AC-6', 'MP-2', 'AT-2']

  ref 'https://learn.microsoft.com/en-us/sharepoint/turn-external-sharing-on-or-off'
  ref 'https://learn.microsoft.com/en-us/sharepoint/external-sharing-overview'

  ensure_spo_guest_users_cannot_share_items_dont_own_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $clientSecret = '#{input('client_secret')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $sharepoint_admin_url = '#{input('sharepoint_admin_url')}'
    import-module pnp.powershell
    $password = (ConvertTo-SecureString -AsPlainText $certificate_password -Force)
    Connect-PnPOnline -Url $sharepoint_admin_url -ClientId $client_id -CertificatePath $certificate_path -CertificatePassword $password  -Tenant $tenantid
	  (Get-PnPTenant).PreventExternalUsersFromResharing
  }
  powershell_output = powershell(ensure_spo_guest_users_cannot_share_items_dont_own_script).stdout.strip
  describe 'Ensure the PreventExternalUsersFromResharing option for SharePoint' do
    subject { powershell_output }
    it 'is set to True' do
      expect(subject).to eq('True')
    end
  end
end
