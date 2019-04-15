Feature: See Rankings

    As an admin,
    So that I can run the matching algorithm and see the results,
    I want to see the matching results for my projects.

    Background: user is logged in
        Given a user with the email "turese@berkeley.edu" with password "password" and with username "turese" exists
        And a registered user with the username "turese" has a project named "p1"
        And a registered user with the username "turese" has a project named "p2"
        And a default matching exists for project with id "1"
        And a user with the email "lawrencechen14@berkeley.edu" with password "password" and with username "lawrencechen14" exists
        And a registered user with the username "lawrencechen14" has a project named "permissiondenied"
        And I am on the login page
        And I fill in "Email" with "turese@berkeley.edu"
        And I fill in "Password" with "password"
        And I press "Log In"

  
    Scenario: User views matchings for a project they do have access to
        When I access the matchings page for project of id "1"
        Then I should see /Event(\s*)People(\s*)Time/
        Then I should see /Person3-0(\s*)Person3(\s*)Fri, 22 Mar 2019 13:00:00 GMT/
        Then I should see /Person1-0(\s*)Person1(\s*)Fri, 22 Mar 2019 14:00:00 GMT/
        Then I should see /Person2-0(\s*)Person2(\s*)Fri, 22 Mar 2019 15:00:00 GMT/
    Scenario: User tries to view matchings for a project with no matchings yet
        When I access the matchings page for project of id "2"
        Then I should see "No matching for this project."

    Scenario: User tries to view matchings for a project they don't have privileges to see
        When I access the matchings page for project of id "3"
        Then I should see "Permission denied."

    Scenario: User tries to view matchings for a project that does not exist
        When I access the matchings page for project of id "4"
        Then I should see "No such project exists."