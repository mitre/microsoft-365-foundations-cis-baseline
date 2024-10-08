control 'microsoft-365-foundations-5.1.5.1' do
  title 'Ensure the Application Usage report is reviewed at least weekly'
  desc "The Application Usage report includes a usage summary for all Software as a Service (SaaS) applications that are integrated with the organization's directory."

  desc 'check',
       'To verify the report is being reviewed at least weekly, confirm that the necessary procedures are in place and being followed.'

  desc 'fix',
       "To review the Application Usage report:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Applications select Enterprise applications.
        3. Under Activity select Usage & insights.
        4. Review the information."

  desc 'rationale',
       'Review the list of app registrations on a regular basis to look for risky apps that users
        have enabled that could cause data spillage or accidental elevation of privilege.
        Attackers can often get access to data illicitly through third-party SaaS applications.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['8.11'] }, { '7' => ['6.2'] }]
  tag nist: ['AU-6', 'AU-6(1)', 'AU-7(1)', 'AC-1', 'AC-2', 'AC-2(1)']

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
