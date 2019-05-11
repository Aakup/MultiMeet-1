Feature: Roster

  As a logged in user,
  So that I can display my roster,
  I can add a new participant to my roster.

  Background: user is logged in
    Given a user with the email "aaronli98@berkeley.edu" with password "password" and with username "aaronli98" exists
    And a registered user with the username "aaronli98" has a project named "Test Meeting 1"
    And a registered user with the username "aaronli98" has a project named "Test Meeting 2"
    And I am on the login page
    When I fill in "Email" with "aaronli98@berkeley.edu"
    And I fill in "Password" with "password"
    And I press "Log In"
    Then I should be on the projects page
    And I should see "aaronli98"

  Scenario: successfully create a new project
    When I follow "New Project"
    Then I should see "Enter the name of your new project here"
    When I fill in "Project Name" with "Test Meeting 3"
    And I press "Create Project"
    Then I should be on the projects page
    And I should see "Successfully created project Test Meeting 3"

  Scenario: successfully display rosters
    When I am on the roster page for "Test Meeting 1"
    Then I should see "Listing Participants"
    When I fill in "Email" with "testing1@berkeley.edu"
    And I press "Add New Participant"
    And I fill in "Email" with "testing2@berkeley.edu"
    And I press "Add New Participant"
    And I fill in "Email" with "testing3@berkeley.edu"
    And I press "Add New Participant"
    Then I should see "Successfully created participant testing3@berkeley.edu"
    When I fill in "Email" with "testing3@berkeley.edu"
    And I press "Add New Participant"
    Then I should see "Participant's email already exists"
    When I follow "Back to Project"
    Then I should see "Test Meeting 1"
    When I am on the roster page for "Test Meeting 1"
    Then I should see "testing1@berkeley.edu"
    Then I should see "testing2@berkeley.edu"
    Then I should see "testing3@berkeley.edu"
    When I follow "Back to Project"
    Then I should see "Test Meeting 1"

  Scenario: successfully rename a project
    When I am on the edit page for "Test Meeting 1"
    Then I should see "Renaming Project"
    When I fill in "New Project Name" with "Testing Meeting 1_1"
    And I press "Confirm Renaming"
    Then I should see "Successfully renamed project to Testing Meeting 1_1"
    And I should see "Testing Meeting 1_1"

  Scenario: successfully destroy a participant
    When I am on the roster page for "Test Meeting 2"
    Then I should see "Listing Participants"
    When I fill in "Email" with "testing4@berkeley.edu"
    And I press "Add New Participant"
    When I follow "DELETE"
    Then I should not see "testing4@berkeley.edu"
    When I follow "Back to Project"
    Then I should see "Test Meeting 2"

  Scenario: successfully email roster
    When I press the roster bottom for project of id "1"
    When I fill in "Email" with "daniellee0228@berkeley.edu"
    And I press "Add New Participant"
    And I fill in "email_body" with "Hello, please give me your availability"
    And I press "Send email to participants"
    Then the participant should receive an email
    Then I should see "Emails have been sent."
  
  Scenario: If correct secret_id, render edit preference page
    When I press the roster bottom for project of id "1"
    When I fill in "Email" with "daniellee0228@berkeley.edu"
    And I press "Add New Participant"
    And I fill in "email_body" with "Hello, please give me your availability"
    And I press "Send email to participants"
    Then the participant should receive an email
    Then I should see "Emails have been sent."
    When I visit the link from the email for project of id "1" and participant of id "1"
    Then I should not see "Access denied"
    
  Scenario: If incorrect secret_id, deny access
    When I press the roster bottom for project of id "1"
    When I fill in "Email" with "daniellee0228@berkeley.edu"
    And I press "Add New Participant"
    And I fill in "email_body" with "Hello, please give me your availability"
    And I press "Send email to participants"
    Then the participant should receive an email
    Then I should see "Emails have been sent."
    When I visit the bad link from the email for project of id "1" and participant of id "1"
    Then I should see "Access denied"

  
  Scenario: "Last Responded" should update with datetime of last response
    Given a registered user with the username "aaronli98" has a project named "Participants Test"
    And the project named "Participants Test" has the following participants:
    | email                       |
    | andrew.huang@berkeley.edu   |
    | jsluong@berkeley.edu        |

    And the project named "Participants Test" has the following times:
    | datetime            |
    | Dec 1 2019 10:00 AM |
    | Dec 1 2019 1:00 PM  |
    | Dec 8 2019 3:00 PM  |

    When I am on the roster page for "Participants Test"
    Then I should see "No response yet"
    When 1 people submitted preferences for "Participants Test"
    And I am on the roster page for "Participants Test"
    Then I should see "No response yet"
    When 2 people submitted preferences for "Participants Test"
    And I am on the roster page for "Participants Test"
    Then I should not see "No response yet"

  Scenario: "Last Responded" should update with autofill rankings
    Given a registered user with the username "aaronli98" has a project named "Autofill Rankings Test"
    And the project named "Autofill Rankings Test" has the following participants:
    | email                       |
    | andrew.huang@berkeley.edu   |

    And the project named "Autofill Rankings Test" has the following times:
    | datetime            |
    | Dec 1 2019 10:00 AM |
    | Dec 1 2019 1:00 PM  |
    | Dec 8 2019 3:00 PM  |

    When I am on the roster page for "Autofill Rankings Test"
    Then I should see "No response yet"
    When I am on the matchings page for "Autofill Rankings Test"
    Then I should see "Not everyone has submitted preferences."
    When I am on the roster page for "Autofill Rankings Test"
    When I follow "Autofill Rankings"
    Then I should not see "No response yet"
    When I follow "Autofill Rankings"
    Then I should not see "No response yet"
    When I am on the matchings page for "Autofill Rankings Test"
    Then I should see "Ready to match."
    And I press "Match!"
    Then I should be on the matchings page for "Autofill Rankings Test"
    And I should see "successfully matched."
    Then I press "Run algorithm again"
    And I should see "Matching Complete."

