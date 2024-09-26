control 'microsoft-365-foundations-2.4.4' do
  title 'Ensure Zero-hour auto purge for Microsoft Teams is on'
  desc 'Zero-hour auto purge (ZAP) is a protection feature that retroactively detects and neutralizes malware and high confidence phishing. When ZAP for Teams protection blocks a message, the message is blocked for everyone in the chat. The initial block happens right after delivery, but ZAP occurs up to 48 hours after delivery.'

  desc 'check',
       "To audit using the UI:
        1.Navigate to Microsoft Defender https://security.microsoft.com/
        2.Click Settings > Email & collaboration > Microsoft Teams protection.
        3.Ensure Zero-hour auto purge (ZAP) is set to On (Default)
        4.Under Exclude these participants review the list of exclusions and ensure they are justified and within tolerance for the organization.
    To audit using PowerShell:
        1.Connect to Exchange Online using Connect-ExchangeOnline.
          2.Run the following cmdlets:
            Get-TeamsProtectionPolicy | fl ZapEnabled
            Get-TeamsProtectionPolicyRule | fl ExceptIf*
        3.Ensure ZapEnabled is True.
        4.Review the list of exclusions and ensure they are justified and within tolerance for the organization. If nothing returns from the 2nd cmdlet then there are no exclusions defined."

  desc 'fix',
       'To remediate using the UI:
        1.Navigate to Microsoft Defender https://security.microsoft.com/
        2.Click Settings > Email & collaboration > Microsoft Teams protection.
        3.Set Zero-hour auto purge (ZAP) to On (Default)
    To remediate using PowerShell:
        1.Connect to Exchange Online using Connect-ExchangeOnline.
        2.Run the following cmdlet:
            Set-TeamsProtectionPolicy -Identity "Teams Protection Policy" -ZapEnabled $true'

  desc 'rationale',
       'ZAP is intended to protect users that have received zero-day malware messages or
        content that is weaponized after being delivered to users. It does this by continually
        monitoring spam and malware signatures taking automated retroactive action on
        messages that have already been delivered.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['10.1'] }]
  tag default_value: 'On (Default)'
  tag nist: ['SI-3']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/zero-hour-auto-purge?view=o365-worldwide#zero-hour-auto-purge-zap-in-microsoft-teams'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/mdo-support-teams-about?view=o365-worldwide#configure-zap-for-teams-protection-in-defender-for-office-365-plan-2'

  ensure_zap_enabled_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    $zapEnabledValue = Get-TeamsProtectionPolicy | Select-Object -ExpandProperty ZapEnabled
    Write-Host $zapEnabledValue
 }
  check_exclusions_script = %{
  $client_id = '#{input('client_id')}'
  $certificate_password = '#{input('certificate_password')}'
  $certificate_path = '#{input('certificate_path')}'
  $organization = '#{input('organization')}'
  import-module exchangeonlinemanagement
  Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
  $zapEnabledValue = Get-TeamsProtectionPolicy | Select-Object -ExpandProperty ZapEnabled
  $rules = Get-TeamsProtectionPolicyRule
  $filteredRules = $rules | ForEach-Object {
      $exceptIfData = $_ | Select-Object -Property * | Where-Object { $_.PSObject.Properties.Name -like 'ExceptIf*' }
      $exceptIfDataString = $exceptIfData | Out-String
      $exceptIfDataString
  }
  $filteredRules
}

  powershell_output_zap = powershell(ensure_zap_enabled_script)
  describe 'Ensure the ZapEnabled option for Default Sharing Policy' do
    subject { powershell_output_zap.stdout.strip }
    it 'is set to True' do
      expect(subject).to eq('True')
    end
  end

  powershell_output_exclusions = powershell(check_exclusions_script)
  describe 'Ensure that the list of exclusions' do
    subject { powershell_output_exclusions.stdout.strip }
    it 'is empty. In case of failure, a manual review is required to check the justification of each present exclusion.' do
      expect(subject).to be_empty
    end
  end
end
