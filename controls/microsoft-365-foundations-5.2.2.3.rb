control 'microsoft-365-foundations-5.2.2.3' do
  title 'Enable Conditional Access policies to block legacy authentication'
  desc "Entra ID supports the most widely used authentication and authorization protocols including legacy authentication. This authentication pattern includes basic authentication, a widely used industry-standard method for collecting username and password information.
        The following messaging protocols support legacy authentication:
            • Authenticated SMTP - Used to send authenticated email messages.
            • Autodiscover - Used by Outlook and EAS clients to find and connect to mailboxes in Exchange Online.
            • Exchange ActiveSync (EAS) - Used to connect to mailboxes in Exchange Online.
            • Exchange Online PowerShell - Used to connect to Exchange Online with remote PowerShell. If you block Basic authentication for Exchange Online PowerShell, you need to use the Exchange Online PowerShell Module to connect. For instructions, see Connect to Exchange Online PowerShell using multifactor authentication.
            • Exchange Web Services (EWS) - A programming interface that's used by Outlook, Outlook for Mac, and third-party apps.
            • IMAP4 - Used by IMAP email clients.
            • MAPI over HTTP (MAPI/HTTP) - Primary mailbox access protocol used by Outlook 2010 SP2 and later.
            • Offline Address Book (OAB) - A copy of address list collections that are downloaded and used by Outlook.
            • Outlook Anywhere (RPC over HTTP) - Legacy mailbox access protocol supported by all current Outlook versions.
            • POP3 - Used by POP email clients.
            • Reporting Web Services - Used to retrieve report data in Exchange Online.
            • Universal Outlook - Used by the Mail and Calendar app for Windows 10.
            • Other clients - Other protocols identified as utilizing legacy authentication."

  desc 'check',
       "Ensure a Conditional Access policy to block legacy authentication is enabled:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click expand Protection > Conditional Access select Policies.
        3. Verify that either the policy Baseline policy: Block legacy authentication is set to On or find another with the following settings enabled:
            o Under Conditions then Client apps ensure the settings are enabled for and Exchange ActiveSync clients and other clients.
            o Under Access controls ensure the Grant is set to Block access
            o Under Assignments ensure All users is enabled
            o Under Assignments and Users and groups ensure the Exclude is set to least one low risk account or directory role. This is required as a best practice.
        This information is also available via the Microsoft Graph Security API:
            GET https://graph.microsoft.com/beta/security/secureScores

        More Granular Instructions:

        To verify basic authentication is disabled, use the Exchange Online PowerShell Module:
            1. Run the Microsoft Exchange Online PowerShell Module.
            2. Connect using Connect-ExchangeOnline.
            3. Run the following PowerShell command:
                Get-OrganizationConfig | Select-Object -ExpandProperty
                DefaultAuthenticationPolicy | ForEach { Get-AuthenticationPolicy $_ | Select-Object AllowBasicAuth* }
            4. Verify each of the basic authentication types is set to false. If no results are shown or an error is displayed, then no default authentication policy has been defined for your organization.
            5. Verify Exchange Online users are configured to use the appropriate authentication policy (in this case Block Basic Auth) by running the following PowerShell command:
                Get-User -ResultSize Unlimited | Select-Object UserPrincipalName, AuthenticationPolicy"

  desc 'fix',
       'To setup a conditional access policy to block legacy authentication, use the following steps:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click expand Protection > Conditional Access select Policies.
        3. Create a new policy by selecting New policy.
        4. Set the following conditions within the policy.
            o Select Conditions then Client apps enable the settings for and Exchange ActiveSync clients and other clients.
            o Under Access controls set the Grant section to Block access
            o Under Assignments enable All users
            o Under Assignments and Users and groups set the Exclude to be at least one low risk account or directory role. This is required as a best practice.

        More Granular Instructions:

        To disable basic authentication, use the Exchange Online PowerShell Module:
            1. Run the Microsoft Exchange Online PowerShell Module.
            2. Connect using Connect-ExchangeOnline.
            3. Run the following PowerShell command:
        *Note: If a policy exists and a command fails you may run Remove-AuthenticationPolicy first to ensure policy creation/application occurs as expected.
            $AuthenticationPolicy = Get-OrganizationConfig | Select-Object DefaultAuthenticationPolicy
            If (-not $AuthenticationPolicy.Identity) {
                $AuthenticationPolicy = New-AuthenticationPolicy "Block Basic Auth"
                Set-OrganizationConfig -DefaultAuthenticationPolicy $AuthenticationPolicy.Identity
            }
            Set-AuthenticationPolicy -Identity $AuthenticationPolicy.Identity -AllowBasicAuthActiveSync:$false -AllowBasicAuthAutodiscover:$false -AllowBasicAuthImap:$false -AllowBasicAuthMapi:$false -AllowBasicAuthOfflineAddressBook:$false -AllowBasicAuthOutlookService:$false -AllowBasicAuthPop:$false -AllowBasicAuthPowershell:$false -AllowBasicAuthReportingWebServices:$false -AllowBasicAuthRpc:$false -AllowBasicAuthSmtp:$false -AllowBasicAuthWebServices:$false
            Get-User -ResultSize Unlimited | ForEach-Object { Set-User -Identity $_.Identity -AuthenticationPolicy $AuthenticationPolicy.Identity -STSRefreshTokensValidFrom $([System.DateTime]::UtcNow) }'

  desc 'rationale',
       'Legacy authentication protocols do not support multi-factor authentication. These
        protocols are often used by attackers because of this deficiency. Blocking legacy
        authentication makes it harder for attackers to gain access.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['4.8'] }, { '7' => ['9.2'] }]
  tag nist: ['CM-6', 'CM-7', 'SI-8']

  ref 'https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/disable-basic-authentication-in-exchange-online'
  ref 'https://learn.microsoft.com/en-us/exchange/mail-flow-best-practices/how-to-set-up-a-multifunction-device-or-application-to-send-email-using-microsoft-365-or-office-365'
  ref 'https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/deprecation-of-basic-authentication-exchange-online'

  check_basic_authentication_types_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    $defaultPolicy = Get-OrganizationConfig | Select-Object -ExpandProperty DefaultAuthenticationPolicy
    $authSettings = Get-AuthenticationPolicy $defaultPolicy | Select-Object AllowBasicAuth*
    $trueSettings = $authSettings.PSObject.Properties | Where-Object { $_.Value -eq $true } | Select-Object Name, Value
    $jsonOutput = $trueSettings | ConvertTo-Json
  }
  powershell_authentication_types_output = powershell(check_basic_authentication_types_script).stdout.strip

  authentication_policy_data = JSON.parse(powershell_authentication_types_output) unless powershell_authentication_types_output.empty?
  describe 'Ensure there is no Conditional Access policy that' do
    subject { authentication_policy_data }
    it 'with a AllowBasicAuth* state set to True' do
      failure_message = "Policies that failed: #{JSON.pretty_generate(authentication_policy_data)}"
      expect(subject).to be_nil, failure_message
    end
  end
  check_authentication_block_basic_auth_policy_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    $users = Get-User -ResultSize Unlimited | Where-Object { $_.AuthenticationPolicy -ne "Block Basic Auth" } | Select-Object UserPrincipalName, AuthenticationPolicy
    $jsonOutput = $users | ConvertTo-Json
    $jsonOutput
    }
  powershell_block_basic_output = powershell(check_authentication_block_basic_auth_policy_script).stdout.strip

  block_basic_policy_data = JSON.parse(powershell_block_basic_output) unless powershell_block_basic_output.empty?
  describe 'Ensure there is no Exchange Online User' do
    subject { block_basic_policy_data }
    it 'with AuthenticationPolicy state that is not Block Basic Auth' do
      failure_message = "Users that failed: #{JSON.pretty_generate(block_basic_policy_data)}"
      expect(subject).to be_nil, failure_message
    end
  end
end
