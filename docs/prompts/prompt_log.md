# Prompt Logs

# Prompts used to guide step by step

1. **Step 1: Create project**
    - Generate `backend/`, `frontend/`, and tests/ folders if not exists).
    - Add .gitignore file for backend and frontend projects
    - Add basic config files (`package.json`, `tsconfig.json`, etc.).
    - Add `cv_files/` for local CV storage.
    
2. **Step 2: Implement backend**    
    - Build backend structure and endpoints per [backend-design.md](vscode-file://vscode-app/c:/Users/ronald.luna/AppData/Local/Programs/Microsoft%20VS%20Code/3c631b164c/resources/app/out/vs/code/electron-browser/workbench/workbench.html).
    - Implement `POST /api/v1/candidates` with CV upload to `cv_files`.
    - Implement `GET /api/v1/candidates`, `PATCH /api/v1/candidates/{id}`, and `GET /api/v1/candidates/{id}/cv`.
3. **Step 3: Implement frontend**
    
    - Build React pages and components per [frontend-design.md](vscode-file://vscode-app/c:/Users/ronald.luna/AppData/Local/Programs/Microsoft%20VS%20Code/3c631b164c/resources/app/out/vs/code/electron-browser/workbench/workbench.html).
    - Implement registration form and admin panel.
    - Integrate with backend API.
4. **Step 4: Add tests**
    
    - Create unit tests in [unit](vscode-file://vscode-app/c:/Users/ronald.luna/AppData/Local/Programs/Microsoft%20VS%20Code/3c631b164c/resources/app/out/vs/code/electron-browser/workbench/workbench.html).
    - Add integration tests in [integration](vscode-file://vscode-app/c:/Users/ronald.luna/AppData/Local/Programs/Microsoft%20VS%20Code/3c631b164c/resources/app/out/vs/code/electron-browser/workbench/workbench.html).
    - Add E2E tests in [e2e](vscode-file://vscode-app/c:/Users/ronald.luna/AppData/Local/Programs/Microsoft%20VS%20Code/3c631b164c/resources/app/out/vs/code/electron-browser/workbench/workbench.html).
5. **Step 5: Follow feature docs**
    
    - Implement features from:
        - [canditate-registration.md](vscode-file://vscode-app/c:/Users/ronald.luna/AppData/Local/Programs/Microsoft%20VS%20Code/3c631b164c/resources/app/out/vs/code/electron-browser/workbench/workbench.html)
        - [admin_panel.md](vscode-file://vscode-app/c:/Users/ronald.luna/AppData/Local/Programs/Microsoft%20VS%20Code/3c631b164c/resources/app/out/vs/code/electron-browser/workbench/workbench.html)
6. **Step 6: Validate against docs**
    
    - Confirm API responses match [error-contract.md](vscode-file://vscode-app/c:/Users/ronald.luna/AppData/Local/Programs/Microsoft%20VS%20Code/3c631b164c/resources/app/out/vs/code/electron-browser/workbench/workbench.html).
    - Confirm CVs are stored in `cv_files`.
    - Confirm `cv_url` points to `/api/v1/candidates/{id}/cv`.
# Prompts used for asking to AI

| Date       | Feature                          | Prompt Summary                                                                                                                                                                        | Manual Edits                                                                                                            |
| :--------- | :------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :---------------------------------------------------------------------------------------------------------------------- |
| 2026-06-10 | Backend Init                     | Initialized schema for candidates                                                                                                                                                     | None                                                                                                                    |
| 2026-06-10 | Project Review                   | Asked assistant "no modifiques nada... solo dime que entiendes del proyecto"; assistant summarized project scope and API                                                              | None                                                                                                                    |
| 2026-06-10 | Documentation Request            | User requested to document fully as SDD with BDD and TDD; assistant generated `docs/api_spec.yaml`, `docs/planning.md`, `docs/done.md`, `docs/architecture.md`, and BDD feature files | Added/updated multiple docs files                                                                                       |
| 2026-06-10 | Language Conversion              | User requested docs in English; assistant converted key docs to English (`planning.md`, `done.md`, `architecture.md`)                                                                 | Updated docs files                                                                                                      |
| 2026-06-11 | Domain Models Doc                | User asked where static/data-models models live; assistant documented domain classes in `docs/diagrams/data-model.md`                                                                          | Added `docs/diagrams/data-model.md`                                                                                         |
| 2026-06-11 | Validation Rules                 | User asked about validations; assistant created `docs/validation.md` with field limits, error payloads, and implementation notes                                                      | Added `docs/validation.md` and updated BDD scenarios in `docs/features/canditate-registration.md`                       |
| 2026-06-11 | Error Payloads & BDD Consistency | Assistant added standardized error examples and updated admin and registration feature scenarios to reference HTTP codes and messages                                                 | Updated `docs/validation.md`, `docs/features/canditate-registration.md`, `docs/features/admin_panel.md`, `docs/done.md` |

