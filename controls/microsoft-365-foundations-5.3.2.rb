control "microsoft-365-foundations-5.3.2" do
  title "Ensure 'Access reviews' for Guest Users are configured"
  desc "Access reviews enable administrators to establish an efficient automated process for reviewing group memberships, access to enterprise applications, and role assignments. These reviews can be scheduled to recur regularly, with flexible options for delegating the task of reviewing membership to different members of the organization.
        Ensure Access reviews for Guest Users are configured to be performed no less frequently than monthly."

  desc "check",
       "Verify an access review for Guest Users is in place:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
        2. Click to expand Identity Governance and select Access reviews
        3. Inspect the access reviews, and ensure an access review is created with the following criteria:
            o Overview: Scope is set to Guest users only and status is Active
            o Reviewers: Ensure appropriate reviewer(s) are designated.
            o Settings > General: Mail notifications and Reminders are set to Enable
            o Reviewers: Require reason on approval is set to Enable
            o Scheduling: Frequency is Monthly or more frequent.
            o When completed: Auto apply results to resource is set to Enable
            o When completed: If reviewers don't respond is set to Remove access"

  desc "fix",
       "Create an access review for Guest Users:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
        2. Click to expand Identity Governance and select Access reviews
        3. Click New access review.
        4. Select what to review choose Teams + Groups.
        5. Review Scope set to All Microsoft 365 groups with guest users, do not exclude groups.
        6. Scope set to Guest users only then click Next: Reviews.
        7. Select reviewers an appropriate user that is NOT the guest user themselves.
        8. Duration (in days) at most 3.
        9. Review recurrence is Monthly or more frequent.
        10. End is set to Never, then click Next: Settings.
        11. Check Auto apply results to resource.
        12. Set If reviewers don't respond to Remove access.
        13. Check the following: Justification required, E-mail notifications, Reminders.
        14. Click Next: Review + Create and finally click Create."

  impact 0.5
  tag severity: "medium"
  tag cis_controls: [{ "8" => ["5.1"] }, { "8" => ["5.3"] }]

  ref "https://learn.microsoft.com/en-us/azure/active-directory/governance/create-access-review"
  ref "https://learn.microsoft.com/en-us/azure/active-directory/governance/access-reviews-overview"

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
