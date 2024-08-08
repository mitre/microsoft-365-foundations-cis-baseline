control 'microsoft-365-foundations-2.1.1' do
    title 'Ensure Safe Links for Office Applications is Enabled'
    desc "Enabling Safe Links policy for Office applications allows URL's that exist inside of Office documents and email applications opened by Office, Office Online and Office mobile to be processed against Defender for Office time-of-click verification and rewritten if required.
        Note: E5 Licensing includes a number of Built-in Protection policies. When auditing policies note which policy you are viewing, and keep in mind CIS recommendations often extend the Default or Build-in Policies provided by MS. In order to Pass the highest priority policy must match all settings recommended."
    
    desc 'check'
    'Ensure Safe Links for Office Applications is Enabled:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com
        2. Under Email & collaboration select Policies & rules
        3. Select Threat policies then Safe Links
        4. Inspect each policy and attempt to identify one that matches the parameters outlined below.
        5. Scroll down the pane and click on Edit Protection settings (Global Readers will look for on or off values)
        6. Ensure the following protection settings are set as outlined: Email
                o Checked On: Safe Links checks a list of known, malicious links when users click links in email. URLs are rewritten by default
                o Checked Apply Safe Links to email messages sent within the organization
                o Checked Apply real-time URL scanning for suspicious links and links that point to files
                o Checked Wait for URL scanning to complete before delivering the message
                o Unchecked Do not rewrite URLs, do checks via Safe Links API only.
            Teams
                o Checked On: Safe Links checks a list of known, malicious links when users click links in Microsoft Teams. URLs are not rewritten
            Office 365 Apps
                o Checked On: Safe Links checks a list of known, malicious links when users click links in Microsoft Office apps. URLs are not rewritten
            Click protection settings
                o Checked Track user clicks
                o Unchecked Let users click through the original URL
        7. There is no recommendation for organization branding.
        8. Click close

    To verify the Safe Links policy is enabled, use the Exchange Online PowerShell Module:
        1. Connect using Connect-ExchangeOnline.
        2. Run the following PowerShell command: 
            Get-SafeLinksPolicy | Format-Table Name
        3. Once this returns the list of policies run the following command to view the policies. 
            Get-SafeLinksPolicy -Identity "Policy Name"
        4. Verify the value for the following.
            o EnableSafeLinksForEmail: True
            o EnableSafeLinksForTeams: True
            o EnableSafeLinksForOffice: True
            o TrackClicks: True
            o AllowClickThrough: False
            o ScanUrls: True
            o EnableForInternalSenders: True
            o DeliverMessageAfterScan: True
            o DisableUrlRewrite: False'
    
    desc 'fix'
    'To create a Safe Links policy:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com
        2. Under Email & collaboration select Policies & rules
        3. Select Threat policies then Safe Links
        4. Click on +Create
        5. Name the policy then click Next
        6. In Domains select all valid domains for the organization and Next
        7. Ensure the following URL & click protection settings are defined: Email
                o Checked On: Safe Links checks a list of known, malicious links when users click links in email. URLs are rewritten by default
                o Checked Apply Safe Links to email messages sent within the organization
                o Checked Apply real-time URL scanning for suspicious links and links that point to files
                o Checked Wait for URL scanning to complete before delivering the message
                o Unchecked Do not rewrite URLs, do checks via Safe Links API only.
            Teams
                o Checked On: Safe Links checks a list of known, malicious links when users click links in Microsoft Teams. URLs are not rewritten
            Office 365 Apps
                o Checked On: Safe Links checks a list of known, malicious links when users click links in Microsoft Office apps. URLs are not rewritten
            Click protection settings
                o Checked Track user clicks
                o Unchecked Let users click through the original URL
                o There is no recommendation for organization branding.
        8. Click Next twice and finally Submit

    To create a Safe Links policy using the Exchange Online PowerShell Module:
        1. Connect using Connect-ExchangeOnline.
        2. Run the following PowerShell script to create a policy at highest priority that will apply to all valid domains on the tenant:
            # Create the Policy 
            $params = @{ Name = "CIS SafeLinks Policy" EnableSafeLinksForEmail = $true EnableSafeLinksForTeams = $true EnableSafeLinksForOffice = $true TrackClicks = $true AllowClickThrough = $false ScanUrls = $true EnableForInternalSenders = $true DeliverMessageAfterScan = $true DisableUrlRewrite = $false }
            New-SafeLinksPolicy @params 
            # Create the rule for all users in all valid domains and associate with Policy 
            New-SafeLinksRule -Name "CIS SafeLinks" -SafeLinksPolicy "CIS SafeLinks Policy" -RecipientDomainIs (Get-AcceptedDomain).Name -Priority 0'

    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['10.1'] }, {'7' => ['7.4']}]

    ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/safe-links-policies-configure?view=o365-worldwide'
    ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/set-safelinkspolicy?view=exchange-ps'
    ref 'https://learn.microsoft.com/en-us/defender-office-365/preset-security-policies?view=o365-worldwide'
end
    

