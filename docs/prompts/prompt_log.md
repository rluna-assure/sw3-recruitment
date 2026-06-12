# Prompt Logs

# Prompts used to guide step by step

1. **Step 1: Create project**
    - Generate `src/backend/` and `src/frontend/` folders if not exists).
    - Add .gitignore file for backend and frontend projects
    - Add basic config files (`package.json`, `tsconfig.json`, etc.).
    - Add `src/backend/cv_files/` for local CV storage.
    
2. **Step 2: Implement backend**    
    - Build backend structure and endpoints per architecture.md.
    - Implement `POST /api/v1/candidates` with CV upload to `cv_files`.
    - Implement `GET /api/v1/candidates`, `PATCH /api/v1/candidates/{id}`, and `GET /api/v1/candidates/{id}/cv`.
    - Build React pages and components per architecture.md.
    - Implement registration form and admin panel.
    - Integrate with backend API.
    
3. **Step 3: Add tests**
        - Create unit tests in [unit].
    - Add integration tests in [integration].
    - Add E2E tests in [e2e].
4. **Step 4: Follow feature docs**
    
    - Implement features from:
        - [[canditate-registration.md]]
        - [[admin_panel.md]]
        - [[cv-download]]
5. **Step 5: Validate against docs**
    
    - Confirm API responses match [[error-contract.md]].
    - Confirm CVs are stored in `cv_files`.
    - Confirm `cv_url` points to `/api/v1/candidates/{id}/cv`.
# Prompts used for asking to AI

| Date       | Feature                          | Prompt Summary                                                                                                                                                                        | Manual Edits                                                                                                            |
| :--------- | :------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :---------------------------------------------------------------------------------------------------------------------- |
| 2026-06-10 | Backend Init                     | Initialized schema for candidates                                                                                                                                                     | None                                                                                                                    |
| 2026-06-10 | Project Review                   | Asked assistant "no modifiques nada... solo dime que entiendes del proyecto"; assistant summarized project scope and API                                                              | None                                                                                                                    |
| 2026-06-10 | Documentation Request            | User requested to document fully as SDD with BDD; assistant generated `docs/api_spec.yaml`, `docs/planning.md`, `docs/done.md`, `docs/architecture.md`, and BDD feature files | Added/updated multiple docs files                                                                                       |
| 2026-06-10 | Language Conversion              | User requested docs in English; assistant converted key docs to English (`planning.md`, `done.md`, `architecture.md`)                                                                 | Updated docs files                                                                                                      |
| 2026-06-11 | Domain Models Doc                | User asked where static/data-models models live; assistant documented domain classes in `docs/diagrams/data-model.md`                                                                          | Added `docs/diagrams/data-model.md`                                                                                         |
| 2026-06-11 | Validation Rules                 | User asked about validations; assistant created `docs/validation.md` with field limits, error payloads, and implementation notes                                                      | Added `docs/validation.md` and updated BDD scenarios in `docs/features/canditate-registration.md`                       |
| 2026-06-11 | Error Payloads & BDD Consistency | Assistant added standardized error examples and updated admin and registration feature scenarios to reference HTTP codes and messages                                                 | Updated `docs/validation.md`, `docs/features/canditate-registration.md`, `docs/features/admin_panel.md`, `docs/done.md` |

