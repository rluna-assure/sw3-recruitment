# @Component: [Module or component name, e.g., AdminPanel / Auth / Billing]
# @Epic: [ID or Name of the general epic]
# @Dependencies: [IDs of other required features, e.g., SW3-001]

Feature: [Feature Name] [ID-Code]
  As a [User role / Actor]
  I want to [Action performed in the system]
  So that [Business value or benefit obtained]

  Background:
    Given [Global precondition 1]
    And [Global precondition 2]

  # --- MAIN FLOW / HAPPY PATH ---
  @HappyPath
  Scenario: [Descriptive title of the successful case]
    Given [Initial state or specific context]
    When [Action or event by the user / system]
    Then [Verifiable expected outcome]
    And [Additional technical or UI outcome]

  # --- ALTERNATIVE FLOWS / VALIDATIONS / ERRORS ---
  @AlternativeFlow @ValidationError
  Scenario: [Title of alternative case 1, e.g., Invalid data]
    Given [Initial state]
    When [Action with erroneous or out-of-flow data]
    Then [The system should reject/show error]
    And [Technical status code, e.g., HTTP 400 or 404]

  @AlternativeFlow @EdgeCase
  Scenario: [Title of alternative case 2, e.g., Missing data]
    Given [Initial state]
    When [Action when an element is missing]
    Then [Expected outcome]

  # --- SPECIFIC TECHNICAL RULES FOR THE AI ---
  # @TechnicalNotes
  # - [Note 1: e.g., The endpoint must be a POST method]
  # - [Note 2: e.g., Encrypt the password field using bcrypt]