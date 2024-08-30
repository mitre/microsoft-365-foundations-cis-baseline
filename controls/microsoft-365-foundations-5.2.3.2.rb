control 'microsoft-365-foundations-5.2.3.2' do
  title 'Ensure custom banned passwords lists are used'
  desc "With Entra Password Protection, default global banned password lists are automatically applied to all users in an Entra ID tenant. To support business and security needs, custom banned password lists can be defined. When users change or reset their passwords, these banned password lists are checked to enforce the use of strong passwords.
        A custom banned password list should include some of the following examples:
            • Brand names
            • Product names
            • Locations, such as company headquarters
            • Company-specific internal terms
            • Abbreviations that have specific company meaning"

  desc 'check',
       "Ensure a custom banned password list is in place:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
        2. Click to expand Protection > Authentication methods
        3. Select Password protection
        4. Verify Enforce custom list is set to Yes
        5. Verify Custom banned password list contains entries specific to the organization or matches a pre-determined list."

  desc 'fix',
       "Create a custom banned password list:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
        2. Click to expand Protection > Authentication methods
        3. Select Password protection
        4. Set Enforce custom list to Yes
        5. In Custom banned password list create a list using suggestions outlined in this document.
        6. Click Save
        NOTE: Below is a list of examples that can be used as a starting place. The references section contains more suggestions.
        • Brand names
        • Product names
        • Locations, such as company headquarters
        • Company-specific internal terms
        • Abbreviations that have specific company meaning"

  desc 'rationale',
       "Creating a new password can be difficult regardless of one's technical background. It is
        common to look around one's environment for suggestions when building a password,
        however, this may include picking words specific to the organization as inspiration for a
        password. An adversary may employ what is called a 'mangler' to create permutations
        of these specific words in an attempt to crack passwords or hashes making it easier to
        reach their goal."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['5.2'] }]
  tag nist: ['IA-5(1)']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-password-ban-bad#custom-banned-password-list'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/tutorial-configure-custom-password-protection'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
