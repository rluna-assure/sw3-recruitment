**Feature: Candidate CV Download SW3-003**
  As a recruiter
  I want to securely download or view a candidate's CV
  So that I can evaluate their professional background

  Background:
    Given the admin panel is available
    And there is a candidate registered with a valid PDF CV

  Scenario: Successful CV download
    Given the recruiter requests the CV for a valid candidate ID
    When the system processes the download request
    Then the system should return the PDF file
    And the HTTP response content type should be "application/pdf"

  Scenario: Reject download for invalid candidate
    Given the recruiter requests the CV for a non-existent candidate ID
    When the system processes the download request
    Then the system should return an HTTP 404 with error message "Candidate not found"

  Scenario: Reject download when CV is missing
    Given the recruiter requests the CV for a candidate who has no CV on file
    When the system processes the download request
    Then the system should return an HTTP 404 with error message "File not found"
