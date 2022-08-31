Feature: Save NIST vulnerabilities list on database
  Scenario: Success
    Given that the configured time has been reached
    When the function runs
    Then the NIST vulnerabilites that was modified or published since last execution must be obtained
    And be saved on database

  Scenario: Without any changes or modifications since the last run
    Given that the configured time has been reached
    And the function started running
    When no changes or modifications since the last run have been made
    Then nothing should be saved on database
    And the function must finish with success
