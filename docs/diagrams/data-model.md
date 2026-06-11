# Domain Model Documentation

This document describes the static domain classes and value objects for Recruitment WebApp. These classes represent the core business concepts and should be implemented in the backend domain layer.

## Domain Classes and Enums

### Candidate
Represents a job candidate submitted through the application.

Properties:
- `id` (UUID): Unique identifier for the candidate.
- `name` (String): Candidate full name.
- `email` (String): Candidate email address, must be unique.
- `phone` (String): Candidate phone number.
- `age` (Integer): Candidate age, must be 18 or older.
- `country` (String): Candidate country of residence.
- `city` (String): Candidate city of residence.
- `english_level` (EnglishLevel): Candidate English proficiency level.
- `cv_path` (String): URL or storage path for the uploaded CV PDF.
- `status` (ApplicationStatus): Application review status.
- `createdAt` (DateTime): Timestamp when the candidate was created.

### EnglishLevel (Enum)
Represents the allowed English proficiency levels.

Values:
- `A1`
- `A2`
- `B1`
- `B2`
- `C1`
- `C2`
### ApplicationStatus (Enum)
Represents the allowed status values for a candidate application.

Values:
- `Accepted`
- `Rejected`
- `In Review`
### TrafficLightStatus (Value Object / Utility)
Maps `EnglishLevel` values to traffic-light colors for UI display.

Mapping:
- `B2`, `C1`, `C2` → `green`
- `B1` → `yellow`
- `A1`, `A2` → `red`

## Domain Relationships
- `Candidate` depends on `EnglishLevel` and `ApplicationStatus`.
- `Candidate` uses `TrafficLightStatus` logic to expose a UI-friendly proficiency indication.
## Implementation Notes
These classes should be documented in the `src/domain/` layer as part of the domain model.
- `Candidate` should be an entity with validation rules.
- `EnglishLevel` and `ApplicationStatus` should be enums or value objects.
- `TrafficLightStatus` should be a pure mapping utility in the domain or shared logic layer.
