# AI Agent Instructions - Recruitment WebApp

## 1. Core Principles
- **Language:** All documentation, specs, and features must be in English.
- **Workflow:** Strictly follow SDD, and BDD patterns.
- **Source of Truth:** - `api_spec.yaml` governs data structures and endpoints.
    - `features/*.md` governs functional requirements and acceptance criteria.
- **Code Integrity:** Never implement features or changes without first updating the corresponding test file in `/tests`.

## 2. Development Protocol (The Loop)
Every task must follow this sequence:
1. **Analyze:** Read `docs/context.md` and `api_spec.md`.
2. **Define (BDD):** Create or update a `.md` file in `/features` with the acceptance criteria.
4. **Implement:** Write the minimal code in `/src` to satisfy the test.
5. **Verify:** Confirm the code passes the test and adheres to the `done.md` definition of done.

## 3. Formatting Standards
- All technical documentation must be stored in `.md` files.
- Use Mermaid diagrams in `docs/diagrams/` to visualize workflows or architecture.
- All code blocks must specify the language (e.g., ```TS, ```javascript).
- Ensure all business rules are documented in `docs/context.md`.

## 4. Interaction Guidelines
- If a requirement is ambiguous, ask for clarification before creating files.
- Before refactoring, verify that existing tests pass.