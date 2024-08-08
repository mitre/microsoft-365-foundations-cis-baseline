control 'microsoft-365-foundations-5.1.6.1' do
  title 'Ensure that collaboration invitations are sent to allowed domains only'
  desc "B2B collaboration is a feature within Microsoft Entra External ID that allows for guest invitations to an organization.
        Ensure users can only send invitations to specified domains.
        NOTE: This list works independently from OneDrive for Business and SharePoint Online allow/block lists. To restrict individual file sharing in SharePoint Online, set up an allow or blocklist for OneDrive for Business and SharePoint Online. For instance, in SharePoint or OneDrive users can still share with external users from prohibited domains by using Anyone links if they haven't been disabled."

  desc 'check',
       "Ensure that collaboration invitations are sent to allowed domains only:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > External Identities select External collaboration settings.
        3. Under Collaboration restrictions, verify that Allow invitations only to the specified domains (most restrictive) is selected. Then verify allowed domains are specified under Target domains."

  desc 'fix',
       "To restrict collaboration invitations only to the specified domains:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > External Identities select External collaboration settings.
        3. Under Collaboration restrictions, select Allow invitations only to the specified domains (most restrictive) is selected. Then specify the allowed domains under Target domains."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['6.1'] }, { '7' => ['13.1'] }]

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/external-identities/allow-deny-list'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/external-identities/what-is-b2b'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
