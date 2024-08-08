control 'microsoft-365-foundations-7.3.2' do
  title 'Ensure OneDrive sync is restricted for unmanaged devices'
  desc "Microsoft OneDrive allows users to sign in their cloud tenant account and begin syncing select folders or the entire contents of OneDrive to a local computer. By default, this includes any computer with OneDrive already installed, whether it is Azure Domain Joined or Active Directory Domain joined.
        The recommended state for this setting is Allow syncing only on computers joined to specific domains Enabled: Specify the AD domain GUID(s)"

  desc 'check',
       'To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click Settings followed by OneDrive - Sync
        3. Verify that Allow syncing only on computers joined to specific domains is checked.
        4. Verify that the Active Directory domain GUIDS are listed in the box.
            o Use the Get-ADDomain PowerShell command on the on-premises server to obtain the GUID for each on-premises domain.
    To audit using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService -Url https://tenant-admin.sharepoint.com, replacing "tenant" with the appropriate value.
        2. Run the following PowerShell command:
            Get-SPOTenantSyncClientRestriction | fl TenantRestrictionEnabled,AllowedDomainList
        3. Ensure TenantRestrictionEnabled is set to True and AllowedDomainList contains the trusted domains GUIDs from the on premises environment.'

  desc 'fix',
       'To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click Settings then select OneDrive - Sync.
        3. Check the Allow syncing only on computers joined to specific domains.
        4. Use the Get-ADDomain PowerShell command on the on-premises server to obtain the GUID for each on-premises domain.
        5. Click Save.
    To remediate using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService
        2. Run the following PowerShell command and provide the DomainGuids from the Get-AADomain command:
            Set-SPOTenantSyncClientRestriction -Enable -DomainGuids "786548DD-877B-4760-A749-6B1EFBC1190A; 877564FF-877B-4760-A749-6B1EFBC1190A"
        Note: Utilize the -BlockMacSync:$true parameter if you are not using conditional access to ensure Macs cannot sync.'

  impact 0.5
  tag severity: 'medium'

  ref 'https://learn.microsoft.com/en-US/sharepoint/allow-syncing-only-on-specific-domains?WT.mc_id=365AdminCSH_spo'
  ref 'https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenantsyncclientrestriction?view=sharepoint-ps'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
