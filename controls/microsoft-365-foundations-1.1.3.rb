control "microsoft-365-foundations-1.1.3" do
  title "Ensure that between two and four global admins are designated"
  desc "More than one global administrator should be designated so a single admin can be monitored and to provide redundancy should a single admin leave an organization. Additionally, there should be no more than four global admins set for any tenant. Ideally global administrators will have no licenses assigned to them."

  desc "check",
       'Ensure that between two and four global admins are designated:
        1. Navigate to the Microsoft 365 admin center https://admin.microsoft.com
        2. Select Users > Active Users.
        3. Select Filter then select Global Admins.
        4. Review the list of Global Admins to confirm there are from two to four such accounts.
    To verify the number of global tenant administrators using PowerShell:
        1.Connect to Microsoft Graph using Connect-MgGraph -Scopes Directory.Read.All
        2.Run the following PowerShell script:
            # Determine Id of role using the immutable RoleTemplateId value.
            $globalAdminRole = Get-MgDirectoryRole -Filter "RoleTemplateId eq \'62e90394-69f5-4237-9190-012177145e10\'"
            $globalAdmins = Get-MgDirectoryRoleMember -DirectoryRoleId $globalAdminRole.Id Write-Host "*** There are"
            $globalAdmins.AdditionalProperties.Count "Global Administrators assigned."
    This information is also available via the Microsoft Graph Security API: GET https://graph.microsoft.com/beta/security/secureScores
    Note: When tallying the number of Global Administrators the above does not account for Partner relationships. Those are located under Settings > Partner Relationships and should be reviewed on a reoccurring basis.'

  desc "fix",
       "To correct the number of global tenant administrators:
        1. Navigate to the Microsoft 365 admin center https://admin.microsoft.com
        2. Select Users > Active Users.
        3. In the Search field enter the name of the user to be made a Global Administrator.
        4. To create a new Global Admin:
            1. Select the user's name.
            2. A window will appear to the right.
            3. Select Manage roles.
            4. Select Admin center access.
            5. Check Global Administrator.
            6. Click Save changes.
        5. To remove Global Admins:
            1. Select User.
            2. Under Roles select Manage roles
            3. De-Select the appropriate role.
            4. Click Save changes."

  impact 0.5
  tag severity: "medium"
  tag cis_controls: [{ "8" => ["5.1"] }, { "7" => ["4.1"] }]

  ref "https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.identity.directorymanagement/get-mgdirectoryrole?view=graph-powershell-1.0"
  ref "https://learn.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#role-template-ids"

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
