control 'microsoft-365-foundations-8.2.1' do
  title "Ensure 'external access' is restricted in the Teams admin center"
  desc "This policy setting controls chat with external unmanaged Skype and Teams users. Users in the organization will not be searchable by unmanaged Skype or Teams users and will have to initiate all communications with unmanaged users.
        Note: As of December 2021, the default for Teams external communication is set to 'People in my organization can communicate with Teams users whose accounts aren't managed by an organization.'
        Note #2: Skype for business is deprecated as of July 31, 2021, although these settings may still be valid for a period of time. See the link in the reference section for more information."

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com/.
        2. Click to expand Users select External access.
        3. Under Teams and Skype for Business users in external organizations ensure Block all external domains
            o If the organization's policy allows select Allow only specific external domains and add the allowed domains names.
        4. Under Teams accounts not managed by an organization ensure the slider is set to Off.
        5. Under Skype users ensure the slider is set to Off.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams
        2. Run the following command: Get-CsTenantFederationConfiguration | fl AllowTeamsConsumer,AllowPublicUsers,AllowFederatedUsers,AllowedDomains
            • State: AllowTeamsConsumer is False
            • State: AllowPublicUsers is False
            • State: AllowFederatedUsers is False OR,
            • If: AllowFederatedUsers is True then ensure AllowedDomains contains authorized domain names."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com/.
        2. Click to expand Users select External access.
        3. Under Teams and Skype for Business users in external organizations Select Block all external domains
            o If the organization's policy allows select any allowed external domains.
        4. Under Teams accounts not managed by an organization move the slider to Off.
        5. Under Skype users move the slider is to Off.
        6. Click Save.
    To remediate using PowerShell:
        • Connect to Teams PowerShell using Connect-MicrosoftTeams
        • Run the following command: Set-CsTenantFederationConfiguration -AllowTeamsConsumer False -AllowPublicUsers False -AllowFederatedUsers $false
        • To allow only specific external domains run these commands replacing the example domains with approved domains: Set-CsTenantFederationConfiguration -AllowTeamsConsumer $false -AllowPublicUsers $false -AllowFederatedUsers $true $list = New-Object Collections.Generic.List[String] $list.add(\"contoso.com\") $list.add(\"fabrikam.com\") Set-CsTenantFederationConfiguration -AllowedDomainsAsAList $list
        Default Value:
            • AllowTeamsConsumer : True
            • AllowPublicUsers : True
            • AllowFederatedUsers : True
            • AllowedDomains : AllowAllKnownDomains"

  desc 'rationale',
       'Allowing users to communicate with Skype or Teams users outside of an organization
        presents a potential security threat as external users can interact with organization
        users over Skype for Business or Teams. While legitimate, productivity-improving
        scenarios exist, they are outweighed by the risk of data loss, phishing, and social
        engineering attacks against organization users via Teams.
        Some real-world attacks and exploits delivered via Teams over external access
        channels include:
        • DarkGate malware
        • Social engineering / Phishing attacks by "Midnight Blizzard"
        • GIFShell
        • Username enumeration'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-us/skypeforbusiness/set-up-skype-for-business-online/set-up-skype-for-business-online'
  ref 'https://learn.microsoft.com/en-US/microsoftteams/manage-external-access?WT.mc_id=TeamsAdminCenterCSH'
  ref 'https://cybersecurity.att.com/blogs/security-essentials/darkgate-malware-delivered-via-microsoft-teams-detection-and-response'
  ref 'https://www.microsoft.com/en-us/security/blog/2023/08/02/midnight-blizzard-conducts-targeted-social-engineering-over-microsoft-teams/'
  ref 'https://www.bitdefender.com/blog/hotforsecurity/gifshell-attack-lets-hackers-create-reverse-shell-through-microsoft-teams-gifs/'

  authorized_domains = input('authorized_domains_teams_admin_center')
  domain_pattern = authorized_domains.map { |domain| "'#{domain}'" }.join(', ')
  ensure_external_access_restricted_teams_admin_center_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2('#{input('certificate_path')}','#{input('certificate_password')}')
    Install-Module -Name MicrosoftTeams -Force -AllowClobber
    import-module MicrosoftTeams
    Connect-MicrosoftTeams -Certificate $cert -ApplicationId $client_id -TenantId $tenantid > $null
    $authorizedDomains = @(#{domain_pattern})

    $federationConfig = Get-CsTenantFederationConfiguration

    $allowTeamsConsumer = $federationConfig.AllowTeamsConsumer -eq $false
    $allowPublicUsers = $federationConfig.AllowPublicUsers -eq $false
    $allowFederatedUsers = $federationConfig.AllowFederatedUsers

    if ($allowTeamsConsumer) {
    } else {
        Write-Host "AllowTeamsConsumer is not False"
    }

    if ($allowPublicUsers) {
    } else {
        Write-Host "AllowPublicUsers is not False"
    }

    if (-not $allowFederatedUsers) {
    } else {
        $allowedDomains = $federationConfig.AllowedDomains
        $unauthorizedDomains = $allowedDomains | Where-Object { $_ -notin $authorizedDomains }

        if ($unauthorizedDomains.Count -eq 0) {
        } else {
            Write-Host "There are also unauthorized domains: $unauthorizedDomains"
        }
    }
  }
  powershell_output = powershell(ensure_external_access_restricted_teams_admin_center_script).stdout.strip
  describe 'Ensure the AllowTeamsConsumer, AllowPublicUsers, AllowFederatedUsers, and AllowedDomains' do
    subject { powershell_output }
    it 'are set to appropriate values and authorized domains present' do
      failure_message = "The following failed:\n#{powershell_output}"
      expect(subject).to be_empty, failure_message
    end
  end
end
