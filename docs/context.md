## 1. Project Vision

See `docs/vision.md` for the Project Vision, goals, file upload policy, and summary user stories.

## 2. Domain Model (Entities)

### Candidate

check the domain in diagrams/domain.md

## 3. Business Rules

### Traffic-Light System (English Proficiency)

Used to visualize candidate suitability across the entire application:

- **Green (Target):** B2, C1, C2
- **Yellow (Intermediate):** B1
- **Red (Below target):** A1, A2
    
### File Upload Policy
- **Format:** PDF only.
- **Size Limit:** Max 5MB per file.
- **Mandatory:** CV is required for a successful application.
## 4. User Stories

- **As a candidate**, I want to submit my professional information and upload my CV so that I can apply for a position.
- **As a recruiter**, I want to view a list of all candidates so that I can keep track of incoming applications.
- **As a recruiter**, I want to filter candidates by country and English level so that I can prioritize highly qualified individuals.
- **As a recruiter**, I want to update a candidate's status ("Accepted", "Rejected", "In Review") so that the recruitment pipeline remains updated.
## 5. Global Constraints

- All public forms must be **responsive** (mobile-first approach).
- All API communication must be secured and validated.
- The system must adhere to **Clean Architecture** principles as defined in `docs/architecture.md`.