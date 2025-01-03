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
  tag nist: ['IR-1', 'IR-8', 'RA-5', 'AU-1', 'AU-2']

  ensure_notifications_for_internal_users_sending_malware_script = %{
    $policies = Get-MalwareFilterPolicy | Select-Object Identity, EnableInternalSenderAdminNotifications, InternalSenderAdminAddress

    foreach ($policy in $policies) {
        $failedConditions = @()

        if ($policy.EnableInternalSenderAdminNotifications -eq $false) {
            $failedConditions += "EnableInternalSenderAdminNotifications"
        }
        if ([string]::IsNullOrEmpty($policy.InternalSenderAdminAddress)) {
            $failedConditions += "InternalSenderAdminAddress"
        }

        if ($failedConditions.Count -gt 0) {
            Write-Output "Policy Name: $($policy.Identity), Failed Conditions = [$($failedConditions -join ', ')]"
        }
    }
 }
  powershell_output = pwsh_single_session_executor(ensure_notifications_for_internal_users_sending_malware_script).run_script_in_graph_exchange
  raise Inspec::Error, "The powershell output returned the following error:  #{powershell_output.stderr}" if powershell_output.exit_status != 0

  describe 'Ensure the number of policies that have the settings EnableInternalSenderAdminNotifications as True and InternalSenderAdminAddress should not be empty' do
    subject { powershell_output.stdout.strip }
    it 'is 0' do
      failure_message = "The following policies have failed along with conditions they have failed on: #{powershell_output.stdout.strip.split("\n").join(',')}"
      expect(subject).to be_empty, failure_message
    end
  end
end
