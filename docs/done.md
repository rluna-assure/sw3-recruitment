# Definition of Done

For Recruitment WebApp to be considered complete, it must meet the following criteria:

## Documentation
- `docs/context.md` includes the domain model and business rules.
- `docs/api_spec.yaml` covers all endpoints, parameters, and schemas.
- `docs/architecture.md` describes backend, frontend, and layer separation.
- `docs/planning.md` documents the SDD and BDD approach.
- `docs/features/*.md` contains clear, verifiable BDD scenarios.
- `docs/done.md` defines measurable acceptance criteria.
 - `docs/validation.md` documents concrete validation rules, field limits, and error payload formats.

## Quality and Testing
- Unit tests exist for domain logic and validations.
- Integration tests exist for critical endpoints.
- End-to-end tests exist for primary user flows.
- All relevant tests pass successfully.

## Implementation
- Backend implements the contract defined in `docs/api_spec.yaml`.
- Frontend implements the registration form and admin panel.
- Persistent storage saves candidates and CVs according to domain rules.
- Application statuses and English levels are handled correctly.

## Acceptance
- Candidates can register with a valid PDF CV.
- Country and English level filters work in the admin panel.
- Application status can be updated to `Accepted`, `Rejected`, or `In Review`.
- Traffic-light logic correctly classifies English proficiency levels.
- The application returns clear error responses for invalid input.

## Checklist
- [ ] Review the documentation to understand the idea.
- [ ] BDD scenarios are defined for each main flow
- [ ] Create projects backend and frontend
- [ ] Implement /docs/features
- [ ] Tests are designed after implementation
