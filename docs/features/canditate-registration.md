**Feature: Candidate Registration SW3-002**
  As a candidate
  I want to submit my details and CV
  So that I can apply for a position

  Background:
    Given the candidate registration page is available

  Scenario: Successful registration
    Given the candidate provides valid information:
      | name | email | phone | age | country | city | english_level |
      | John Doe | john@example.com | +591 70000000 | 25 | USA | New York | B2 |
    And the candidate uploads a valid PDF CV under 5MB
    When the candidate submits the form
    Then the candidate should be saved in the database
    And the application status should be "In Review"
    And the response should include a valid candidate ID and cv_url

  Scenario: Reject missing CV upload
    Given the candidate provides valid information except no CV
    When the candidate submits the form
    Then the system should return an HTTP 400 with error message "CV is required" and details for field `cv`

  Scenario: Reject invalid file type
    Given the candidate uploads a "text.txt" file
    When the candidate submits the form
    Then the system should return an HTTP 415 with error message "Invalid file format. Only PDF allowed."

  Scenario: Reject file size over limit
    Given the candidate uploads a PDF CV larger than 5MB
    When the candidate submits the form
    Then the system should return an HTTP 413 with error message "CV file size must not exceed 5MB."

  Scenario: Reject underage candidate
    Given the candidate provides age "17"
    When the candidate submits the form
    Then the system should return an HTTP 400 with error message "Age must be 18 or older." and details for field `age`

  Scenario: Reject duplicate email
    Given an existing candidate is registered with email "john@example.com"
    When another candidate submits the same email
    Then the system should return an HTTP 409 with error message "Email already registered." and details for field `email`
