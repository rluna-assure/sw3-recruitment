# Sequence Diagram: Admin Update (No Authentication)

Purpose: Shows the flow for an admin updating a candidate's status via a route without authentication (MVP).

```mermaid
sequenceDiagram
  participant Admin as Admin Browser
  participant Frontend as Admin Frontend
  participant API as API Controller
  participant UseCase as UpdateCandidateStatusUseCase
  participant Repo as CandidateRepository
  participant DB as Postgres

  Admin->>Frontend: click "Accept" on candidate
  Frontend->>API: PATCH /candidates/{id} { status: "Accepted" }
  API->>UseCase: validate payload
  UseCase->>Repo: find candidate by id
  alt candidate exists
    UseCase->>Repo: update status
    Repo->>DB: UPDATE candidate
    Repo-->>UseCase: updated candidate
    UseCase-->>API: 200 OK (updated candidate)
    API-->>Frontend: 200 OK
  else candidate not found
    UseCase-->>API: 404 Not Found
    API-->>Frontend: 404
  end
```

Notes:
- This flow intentionally omits authentication; ensure teams understand security implications and add auth in a future iteration.
