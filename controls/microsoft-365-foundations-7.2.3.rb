control 'microsoft-365-foundations-7.2.3' do
  title 'Ensure external content sharing is restricted'
  desc "The external sharing settings govern sharing for the organization overall. Each site has its own sharing setting that can be set independently, though it must be at the same or more restrictive setting as the organization.
        The new and existing guests option requires people who have received invitations to sign in with their work or school account (if their organization uses Microsoft 365) or a Microsoft account, or to provide a code to verify their identity. Users can share with guests already in your organization's directory, and they can send invitations to people who will be added to the directory if they sign in.
        The recommended state is New and existing guests or less permissive."

  desc 'check',
       "To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Locate the External sharing section.
        4. Under SharePoint, ensure the slider bar is set to New and existing guests or a less permissive level.
    To audit using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following cmdlet:
            Get-SPOTenant | fl SharingCapability
        3. Ensure SharingCapability is set to one of the following values:
            o Value1: ExternalUserSharingOnly
            o Value2: ExistingExternalUserSharingOnly
            o Value3: Disabled"

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Locate the External sharing section.
        4. Under SharePoint, move the slider bar to New and existing guests or a less permissive level.
            o OneDrive will also be moved to the same level and can never be more permissive than SharePoint.
    To remediate using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following cmdlet to establish the minimum recommended state: Set-SPOTenant -SharingCapability ExternalUserSharingOnly
    Note: Other acceptable values for this parameter that are more restrictive include: Disabled and ExistingExternalUserSharingOnly."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['3.3'] }]

  ref 'https://learn.microsoft.com/en-US/sharepoint/turn-external-sharing-on-or-off?WT.mc_id=365AdminCSH_spo'
  ref 'https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenant?view=sharepoint-ps'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
