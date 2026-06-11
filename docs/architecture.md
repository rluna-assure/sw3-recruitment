# Architecture of Recruitment WebApp

## Overview

Recruitment WebApp is a recruitment platform with a React frontend and NestJS backend. The application adheres to N-Layer architecture with Dependency Inversion to keep the core business rules isolated from database and infrastructure technologies.
## Architectural Principles

- **Framework independence:** domain logic does not depend on NestJS, React, or the database.
- **Separation of concerns:** each layer has a single responsibility.
- **Testability:** business rules are testable without external dependencies.
- **Scalability:** the design allows replacing persistence implementations without changing business rules.
## Backend Layers
### 1. Presentation Layer (`src/infrastructure/controllers/`)

- **Responsibility:** Handles the HTTP protocol, routing, and user input validation.
- **Components:** - NestJS Controllers (e.g., `CandidateController`).
    - Input Data Transfer Objects (DTOs) with `class-validator`.
- **Rule:** It only sanitizes data, delegates execution to the Core Layer, and maps responses to HTTP status codes.
### 2. Core / Domain Layer (`src/core/`)

- **Responsibility:** The heart of the application. Contains all business logic and rules.
	**Components:**
    - **Entities & Value Objects:** Pure representations of data and behavior (e.g., `Candidate`, `EnglishLevel`, `ApplicationStatus`).
    - **Business Services:** Orchestrators of logic (e.g., `CandidateService`). They contain methods like `register()`, `list()`, and `updateStatus()`.
    - **Repository Contracts:** Abstract classes or interfaces that define _what_ data operations are needed (e.g., `CandidateRepository`).
- **Rule:** **Strictly independent of the database ORM.** It interacts only with its own repository contracts.
### 3. Infrastructure Layer (`src/infrastructure/`)

- **Responsibility:** Implements technical details and external tools.
- **Components:**    
    - **Database Repositories:** Concrete implementations (e.g., `TypeOrmCandidateRepository`) that fulfill the contracts defined in the Core Layer.
    - **NestJS Modules:** Wiring and configuration of the Dependency Injection container.
    - **External Services:** Third-party integrations (e.g., CV file storage, Email providers).
    - **CV file storage:** Candidate PDFs are stored through a backend file storage path named `cv_files`, and candidate records persist the `cv_path`/`cv_url` that points to that storage location.
## Data & Dependency Flow

1. **Control Flow (Top-Down):** The User triggers the `Presentation Layer` → which invokes the `Core Layer` (Services) → which triggers data persistence via the `Infrastructure Layer`.
    
2. **Dependency Flow (Inverted at the bottom):** The `Presentation Layer` depends on the `Core Layer`. Crucially, the `Infrastructure Layer` **also depends on the Core Layer** because it must implement the contracts defined there.
## Frontend Layers

- **Features:** each functionality is self-contained.
  - `RegistrationForm`
  - `AdminPanel`
- **Services:** HTTP client for API communication.
- **Shared logic:** utilities for traffic-light calculation and enumerations.
## Data Flow
1. The user sends a request from the frontend.
2. The controller receives and validates the request.
3. The use case executes business logic.
4. The domain creates or updates entities.
5. The repository persists or retrieves data.
6. The controller returns the HTTP response.

## REST API

- Base path: `/api/v1`
- Main endpoints:
  - `POST /candidates`
  - `GET /candidates`
  - `PATCH /candidates/{id}`
- The API is stateless and uses standard HTTP status codes.

## Authentication (MVP)

For the initial MVP and documentation-driven implementation, the admin and candidate pages are exposed by route only (no authentication). This accelerates development and testing of the recruitment flows, but is not secure for production use.

Before moving to production, implement an authentication and authorization layer (e.g., JWT for admin sessions) and secure admin routes appropriately.

## Non-functional Rules
- Consistent data formats
- Centralized error handling
- Documentation updated before implementation
- Automated tests for each layer

## SDD, BDD, and TDD Alignment
- SDD: implementation starts from documented requirements.
- BDD: scenarios in `docs/features/` define expected behavior.
- TDD: tests are written before code, and implementation makes them pass.
