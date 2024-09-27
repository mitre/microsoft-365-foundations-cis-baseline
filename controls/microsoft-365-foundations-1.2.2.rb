control 'microsoft-365-foundations-1.2.2' do
  title 'Ensure sign-in to shared mailboxes is blocked'
  desc 'Shared mailboxes are used when multiple people need access to the same mailbox, such as a company information or support email address, reception desk, or other function that might be shared by multiple people.
        Users with permissions to the group mailbox can send as or send on behalf of the mailbox email address if the administrator has given that user permissions to do that. This is particularly useful for help and support mailboxes because users can send emails from "Contoso Support" or "Building A Reception Desk."
        Shared mailboxes are created with a corresponding user account using a system generated password that is unknown at the time of creation.
        The recommended state is Sign in blocked for Shared mailboxes.'

  desc 'check',
       'Review Shared mailboxes in the UI:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com/
        2. Click to expand Teams & groups and select Shared mailboxes.
        3. Take note of all shared mailboxes.
        4. Click to expand Users and select Active users.
        5. Select a shared mailbox account to open its properties pane, and review.
        6. Ensure the option reads Unblock sign-in.
        7. Repeat for any additional shared mailboxes.
    Note: If sign-in is not blocked it will read Block sign-in.
    Audit in PowerShell using 2 modules:
        1. Connect to Exchange Online using Connect-ExchangeOnline
        2. Connect to Microsoft Graph using Connect-MgGraph -Scopes "Policy.Read.All"
        3. Run the following PowerShell commands:
            $MBX = Get-EXOMailbox -RecipientTypeDetails SharedMailbox
            $MBX | ForEach-Object { Get-MgUser -UserId $_.ExternalDirectoryObjectId ` -Property DisplayName, UserPrincipalName, AccountEnabled } | Format-Table DisplayName, UserPrincipalName, AccountEnabled
        4. Ensure AccountEnabled is set to False for all Shared Mailboxes.'

  desc 'fix',
       %q(Block sign-in to shared mailboxes in the UI:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com/
        2. Click to expand Teams & groups and select Shared mailboxes.
        3. Take note of all shared mailboxes.
        4. Click to expand Users and select Active users.
        5. Select a shared mailbox account to open it's properties pane and then select Block sign-in.
        6. Check the box for Block this user from signing in.
        7. Repeat for any additional shared mailboxes."
  'Remediate in PowerShell using 2 modules:
        1. Connect to Microsoft Graph using Connect-MgGraph -Scopes "User.ReadWrite.All"
        2. Connect to Exchange Online using Connect-ExchangeOnline.
        3. To disable sign-in for a single account: $MBX = Get-EXOMailbox -Identity TestUser@example.com Update-MgUser -UserId $MBX.ExternalDirectoryObjectId -AccountEnabled:$false
        3. The following will block sign-in to all Shared Mailboxes. $MBX = Get-EXOMailbox -RecipientTypeDetails SharedMailbox $MBX | ForEach-Object { Update-MgUser -UserId $_.ExternalDirectoryObjectId -AccountEnabled:$false })

  desc 'rationale',
       'Conditional Access, when used as a deny list for the tenant or subscription, is able to prevent ingress or egress of traffic to countries that are outside of the scope of interest (e.g.: customers, suppliers) or jurisdiction of an organization. This is an effective way to prevent unnecessary and long-lasting exposure to international threats such as APTs.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }, { '7' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/admin/email/about-shared-mailboxes?view=o365-worldwide'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/admin/email/create-a-shared-mailbox?view=o365-worldwide#block-sign-in-for-the-shared-mailbox-account'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/enterprise/block-user-accounts-with-microsoft-365-powershell?view=o365-worldwide#block-individual-user-accounts'

  ensure_signin_mailboxes_blocked_script = %{
      $client_id = '#{input('client_id')}'
      $tenantid = '#{input('tenant_id')}'
      $certificate_password = '#{input('certificate_password')}'
      $certificate_path = '#{input('certificate_path')}'
      $organization = '#{input('organization')}'
      $clientSecret = '#{input('client_secret')}'
      import-module microsoft.graph
      import-module exchangeonlinemanagement
      $password = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
      $ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential($client_id,$password)
      Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
      Connect-MgGraph -TenantId "$tenantid" -ClientSecretCredential $ClientSecretCredential -NoWelcome
      Connect-MgGraph -Scopes "Policy.Read.All" -NoWelcome
      $MBX = Get-EXOMailbox -RecipientTypeDetails SharedMailbox
      $disabled_account_count = $MBX | ForEach-Object { Get-MgUser -UserId $_.ExternalDirectoryObjectId ` -Property DisplayName, UserPrincipalName, AccountEnabled } | Where-Object { $_.AccountEnabled -eq $true } | Measure-Object | Select-Object -ExpandProperty Count
      Write-Output $disabled_account_count
   }

  powershell_output = powershell(ensure_signin_mailboxes_blocked_script)
  describe 'Ensure the number of shared mailboxes with AccountEnabled as true' do
    subject { powershell_output.stdout.strip }
    it 'is equal to 0' do
      expect(subject).to cmp(0)
    end
  end
end
