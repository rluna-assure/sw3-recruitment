# Sequence Diagram: Candidate Registration

Purpose: Shows the happy path for a candidate submitting their details and uploading a CV.

```mermaid
sequenceDiagram
  participant Browser as Candidate Browser
  participant Frontend as Frontend (RegistrationForm)
  participant API as API Controller
  participant UseCase as RegisterCandidateUseCase
  participant FileStore as File Storage
  participant Repo as CandidateRepository
  participant DB as Postgres

  Browser->>Frontend: fill form + attach CV (PDF)
  Frontend->>API: POST /candidates (multipart/form-data)
  API->>UseCase: validate payload & file
  UseCase->>FileStore: store CV (generate safe filename)
  FileStore-->>UseCase: cv_path
  UseCase->>Repo: save candidate with cv_path
  Repo->>DB: INSERT candidate
  DB-->>Repo: new candidate id
  Repo-->>UseCase: saved candidate
  UseCase-->>API: 201 Created (id, cv_url)
  API-->>Frontend: response
  Frontend-->>Browser: show success (In Review)
```

Notes:
- File validation (PDF + size limit) occurs at API boundary and in the use-case.
- Errors (validation/file issues) map to standard error responses documented in `docs/validation.md`.
