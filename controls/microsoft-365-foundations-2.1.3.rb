control 'microsoft-365-foundations-2.1.3' do
  title 'Ensure notifications for internal users sending malware is Enabled'
  desc "Exchange Online Protection (EOP) is the cloud-based filtering service that protects organizations against spam, malware, and other email threats. EOP is included in all Microsoft 365 organizations with Exchange Online mailboxes.
        EOP uses flexible anti-malware policies for malware protection settings. These policies can be set to notify Admins of malicious activity."

  desc 'check',
       "Ensure notifications for internal users sending malware is Enabled:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2. Click to expand E-mail & Collaboration select Policies & rules.
        3. On the Policies & rules page select Threat policies.
        4. Under Policies select Anti-malware.
        5. Click on the Default (Default) policy.
        6. Ensure the setting Notify an admin about undelivered messages from internal senders is set to On and that there is at least one email address under Administrator email address.
    To audit using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following command:
            Get-MalwareFilterPolicy | fl Identity, EnableInternalSenderAdminNotifications, InternalSenderAdminAddress
    NOTE: Audit and Remediation guidance may focus on the Default policy however, if a Custom Policy exists in the organization's tenant then ensure the setting is set as outlined in the highest priority policy listed."

  desc 'fix',
       "To enable notifications for internal users sending malware:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2. Click to expand E-mail & Collaboration select Policies & rules.
        3. On the Policies & rules page select Threat policies.
        4. Under Policies select Anti-malware.
        5. Click on the Default (Default) policy.
        6. Click on Edit protection settings and change the settings for Notify an admin about undelivered messages from internal senders to On and enter the email address of the administrator who should be notified under Administrator email address.
        7. Click Save.
    To remediate using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following command:
            Set-MalwareFilterPolicy -Identity '{Identity Name}' -EnableInternalSenderAdminNotifications $True -InternalSenderAdminAddress {admin@domain1.com}
    NOTE: Audit and Remediation guidance may focus on the Default policy however, if a Custom Policy exists in the organization's tenant then ensure the setting is set as outlined in the highest priority policy listed."

  desc 'rationale',
       'This setting alerts administrators that an internal user sent a message that contained malware. This may indicate an account or machine compromise that would need to be investigated.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [
    { '8' => ['17.5'] },
    { '7' => ['7.1'] },
    { '7' => ['8.1'] }
  ]
  tag default_value: "EnableInternalSenderAdminNotifications : False
                      InternalSenderAdminAddress : $null"
  tag nist: ['IR-1', 'IR-8', 'RA-5', 'AU-1', 'AU-2']

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
