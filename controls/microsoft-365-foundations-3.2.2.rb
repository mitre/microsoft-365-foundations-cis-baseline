control "microsoft-365-foundations-3.2.2" do
  title "Ensure DLP policies are enabled for Microsoft Teams"
  desc "The default Teams Data Loss Prevention (DLP) policy rule in Microsoft 365 is a preconfigured rule that is automatically applied to all Teams conversations and channels. The default rule helps prevent accidental sharing of sensitive information by detecting and blocking certain types of content that are deemed sensitive or inappropriate by the organization.
        By default, the rule includes a check for the sensitive info type Credit Card Number which is pre-defined by Microsoft."

  desc "check",
       'To audit the using the UI:
        1. Navigate to Microsoft Purview compliance portal https://compliance.microsoft.com.
        2. Under Solutions select Data loss prevention then Policies.
        3. Locate the Default policy for Teams.
        4. Verify the Status is On.
        5. Verify Locations include Teams chat and channel messages - All accounts.
        6. Verify Policy settings incudes the Default Teams DLP policy rule or one specific to the organization.
    Note: If there is not a default policy for teams inspect existing policies starting with step 4. DLP rules are specific to the organization and each organization should take steps to protect the data that matters to them. The default teams DLP rule will only alert on Credit Card matches.
    To audit using PowerShell:
        1. Connect to the Security & Compliance PowerShell using Connect-IPPSSession.
        2. Run the following to return policies that include Teams chat and channel messages:
            $DlpPolicy = Get-DlpCompliancePolicy
            $DlpPolicy | Where-Object {$_.Workload -match "Teams"} | ft Name,Mode,TeamsLocation*
        3. If nothing returns then there are no policies that include Teams and remediation is required.
        4. For any returned policy verify Mode is set to Enable.
        5. Verify TeamsLocation includes All.
        6. Verify TeamsLocationException includes only permitted exceptions.
    Note: Some tenants may not have a default policy for teams as Microsoft started creating these by default at a particular point in time. In this case a new policy will have to be created that includes a rule to protect data important to the organization such as credit cards and PII.'

  desc "fix",
       "To remediate using the UI:
        1. Navigate to Microsoft Purview compliance portal https://compliance.microsoft.com.
        2. Under Solutions select Data loss prevention then Policies.
        3. Click Policies tab.
        4. Check Default policy for Teams then click Edit policy.
        5. The edit policy window will appear click Next
        6. At the Choose locations to apply the policy page, turn the status toggle to On for Teams chat and channel messages location and then click Next.
        7. On Customized advanced DLP rules page, ensure the Default Teams DLP policy rule Status is On and click Next.
        8. On the Policy mode page, select the radial for Turn it on right away and click Next.
        9. Review all the settings for the created policy on the Review your policy and create it page, and then click submit.
        10. Once the policy has been successfully submitted click Done.
    Note: Some tenants may not have a default policy for teams as Microsoft started creating these by default at a particular point in time. In this case a new policy will have to be created that includes a rule to protect data important to the organization such as credit cards and PII."

  impact 0.5
  tag severity: "medium"
  tag cis_controls: [{ "8" => ["3.1"] }, { "7" => ["13"] }, { "7" => ["14.7"] }]

  ref "https://learn.microsoft.com/en-us/powershell/exchange/connect-to-scc-powershell?view=exchange-ps"
  ref "https://learn.microsoft.com/en-us/purview/dlp-teams-default-policy?view=o365-worldwide%2F1000"
  ref "https://learn.microsoft.com/en-us/powershell/module/exchange/connect-ippssession?view=exchange-ps"

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
