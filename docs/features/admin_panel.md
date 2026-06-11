**Feature: Admin Panel Management SW3-001**
  As a recruiter
  I want to manage applications
  So that I can maintain the hiring pipeline

  Background:
    Given the admin panel is available

  Scenario: Filter candidates by country
    Given there are candidates from "Bolivia" and "USA"
    When the recruiter filters by "Bolivia"
    Then only candidates from "Bolivia" should be displayed

  Scenario: Filter candidates by English level
    Given there are candidates with English levels "B2" and "A1"
    When the recruiter filters by "B2"
    Then only candidates with English level "B2" should be displayed

  Scenario: Update candidate application status
    Given a candidate exists with status "In Review"
    When the recruiter sets the status to "Accepted"
    Then the candidate's status should be updated to "Accepted"

  Scenario: Traffic-light visual status
    Given a candidate has an English level of "C1"
    Then the proficiency indicator should be "green"

  Scenario: Traffic-light visual status for intermediate level
    Given a candidate has an English level of "B1"
    Then the proficiency indicator should be "yellow"

  Scenario: Traffic-light visual status for below target level
    Given a candidate has an English level of "A1"
    Then the proficiency indicator should be "red"

  Scenario: Sort candidates by most recent
    Given there are multiple candidates
    When the recruiter sorts by creation date descending
    Then the most recently submitted candidate should appear first
