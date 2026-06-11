# Planning and Specification for Recruitment WebApp

## Purpose

This document defines the Specification-Driven Development (SDD) approach for the Recruitment WebApp project, including alignment with BDD and TDD. The goal is to provide a clear specification for implementing the backend, frontend, and tests without ambiguity.

## Scope

The project includes:
- Candidate registration with PDF CV upload
- Recruiter admin panel
- Filters and English proficiency visualization
- Application status updates
- Validation and automated testing

## Delivery Objectives

1. Document functional and non-functional requirements.
2. Define the API and data contracts.
3. Create BDD scenarios for critical workflows.
4. Establish a TDD test strategy with unit, integration, and end-to-end test cases.
5. Maintain a clean architecture with separated layers.

## Roles

- Product: defines acceptance criteria and priorities.
- QA/Test: designs and maintains tests based on scenarios.
- Development: implements code from the specifications.

## Timeline and Milestones

- M1: Complete domain documentation (`docs/context.md`), API spec (`docs/api_spec.yaml`), and architecture (`docs/architecture.md`).
- M2: Complete BDD feature documentation in `docs/features/`.
- M3: Document the TDD test plan in `docs/planning.md` and acceptance criteria in `docs/done.md`.
- M4: Execute and verify tests during implementation.

## BDD Feature Map

| Feature | Document | Goal |
|---|---|---|
| Candidate Registration | `docs/features/canditate-registration.md` | Validate candidate intake and PDF CV upload |
| Admin Panel | `docs/features/admin_panel.md` | Filter, view, and update application statuses |
| Traffic Light Logic | `docs/context.md` + `docs/features/admin_panel.md` | Classify English levels visually |

## Test Strategy (TDD)

### Unit Tests
- Validate domain business logic
- Validate English level and status rules
- Validate input validation rules

### Integration Tests
- Validate REST API flows between infrastructure and application layers
- Verify persistence and business rules with realistic data

### End-to-End Tests
- Validate the complete candidate registration flow
- Validate the admin panel and filter flow

## Requirements Traceability

Each BDD story must map to:
- `docs/api_spec.yaml` for the HTTP contract
- `tests/unit` or `tests/integration` for test execution
- `docs/done.md` for final acceptance criteria

## Non-functional Requirements

- Mobile-first responsive UI
- Secure API communication
- Consistent validation and error handling
- Code aligned with Clean Architecture

## Notes

- Tests must be written before implementation for each feature.
- If documentation changes, update the corresponding file immediately.
- Code changes should reference the associated BDD scenario and TDD test case.
