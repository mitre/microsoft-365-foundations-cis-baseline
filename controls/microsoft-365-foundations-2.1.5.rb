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
    $policies = Get-AtpPolicyForO365 | Select-Object Name, EnableATPForSPOTeamsODB, EnableSafeDocs, AllowSafeDocsOpen

    foreach ($policy in $policies) {
        $failedConditions = @()

        if ($policy.EnableATPForSPOTeamsODB -eq $false) {
            $failedConditions += "EnableATPForSPOTeamsODB"
        }
        if ($policy.EnableSafeDocs -eq $false) {
            $failedConditions += "EnableSafeDocs"
        }
        if ($policy.AllowSafeDocsOpen -eq $true) {
            $failedConditions += "AllowSafeDocsOpen"
        }

        if ($failedConditions.Count -gt 0) {
            Write-Output "Policy Name: $($policy.Name), Failed Conditions = [$($failedConditions -join ', ')]"
        }
    }
  }

  powershell_output = pwsh_single_session_executor(ensure_safe_attachments_for_msproducts_enabled_script).run_script_in_graph_exchange
  raise Inspec::Error, "The powershell output returned the following error:  #{powershell_output.stderr}" if powershell_output.exit_status != 0

  describe 'Ensure the number of Safe Attachment Policies that have the settings EnableATPForSPOTeamsODB as False, EnableSafeDocs as False, or AllowSafeDocsOpen as True' do
    subject { powershell_output.stdout ||= '' }
    it 'is 0' do
      failure_message = "The following policies have failed along with conditions they have failed on: #{powershell_output.stdout.strip.split("\n").join(',')}"
      expect(subject).to be_empty, failure_message
    end
  end
end
