control 'microsoft-365-foundations-5.3.3' do
  title "Ensure 'Access reviews' for high privileged Azure AD roles are configured"
  desc "Access reviews enable administrators to establish an efficient automated process for reviewing group memberships, access to enterprise applications, and role assignments. These reviews can be scheduled to recur regularly, with flexible options for delegating the task of reviewing membership to different members of the organization.
        Ensure Access reviews for high privileged Entra ID roles are done no less frequently than weekly. These reviews should include at a minimum the roles listed below:
            • Global Administrator
            • Exchange Administrator
            • SharePoint Administrator
            • Teams Administrator
            • Security Administrator
        NOTE: An access review is created for each role selected after completing the process."

  desc 'check',
       "Verify access reviews for high privileged roles is in place:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
        2. Click to expand Identity Governance and select Privileged Identity Management
        3. Select Microsoft Entra Roles under Manage
        4. Select Access reviews
        5. Ensure there are access reviews configured for each high privileged roles and each meets the criteria laid out below:
            o Scope - Everyone
            o Status - Active
            o Reviewers - Role reviewers should be designated personnel. Preferably not a self-review.
            o Mail notifications - Enable
            o Reminders - Enable
            o Require reason on approval - Enable
            o Frequency - Monthly or more frequent
            o Duration (in days) - 4 at most
            o Auto apply results to resource - Enable
            o If reviewers don't respond - No change
        Any remaining settings are discretionary.
        NOTE: Reviewers will have the ability to revoke roles should be trusted individuals who understand the impact of the access reviews. The principal of separation of duties should be considered so that no one administrator is reviewing their own access levels.
        NOTE2: The setting If reviewers don't respond is recommended to be set to Remove access due to the potential of all Global Administrators being unassigned if the review is not addressed."

  desc 'fix',
       "Create an access review for high privileged roles:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
        2. Click to expand Identity Governance and select Privileged Identity Management
        3. Select Microsoft Entra Roles under Manage
        4. Select Access reviews and click New access review.
        5. Provide a name and description.
        6. Frequency set to Weekly or more frequent.
        7. Duration (in days) is set to at most 3.
        8. End set to Never.
        9. Role select these roles: Global Administrator,Exchange Administrator,SharePoint Administrator,Teams Administrator,Security Administrator
        10. Assignment type set to All active and eligible assignments.
        11. Reviewers set to Selected user(s) or group(s)
        12. Select reviewers are member(s) responsible for this type of review.
        13. Auto apply results to resource set to Enable
        14. If reviewers don't respond is set to No change
        15. Show recommendations set to Enable
        16. Require reason or approval set to Enable
        17. Mail notifications set to Enable
        18. Reminders set to Enable
        19. Click Start to save the review.
    NOTE: Reviewers will have the ability to revoke roles should be trusted individuals who understand the impact of the access reviews. The principle of separation of duties should be considered so that no one administrator is reviewing their own access levels."

  desc 'rationale',
       'Regular review of critical high privileged roles in Entra ID will help identify role drift, or
        potential malicious activity. This will enable the practice and application of "separation of
        duties" where even non-privileged users like security auditors can be assigned to review
        assigned roles in an organization. Furthermore, if configured these reviews can enable
        a fail-closed mechanism to remove access to the subject if the reviewer does not
        respond to the review.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['5.1'] }, { '8' => ['5.3'] }]
  tag default_value: 'By default access reviews are not configured.'
  tag nist: ['AC-2', 'AC-2(3)']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/privileged-identity-management/pim-create-azure-ad-roles-and-resource-roles-review'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/governance/access-reviews-overview'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
