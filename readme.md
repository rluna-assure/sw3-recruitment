# **Recruitment WebApp**

### Overview

A responsive recruitment platform designed to streamline candidate registration and administration. This project allows candidates to submit their profiles and CVs, and enables recruiters to manage applications through an interactive dashboard.

Vision: See [docs/vision.md](docs/vision.md) for the project vision, goals, and user stories.
Features

Public Registration Form: Captures candidate details (name, email, phone, age, country, city, English level) and requires a PDF CV upload.

Admin Panel: View all candidate applications, filter by location or English proficiency.

Traffic-Light Status System: Visual indicators for English proficiency levels:
- Green: **B2, C1, C2**
- Yellow: **B1**
- Red: **A1, A2**

Application Management: Capability to mark candidates as "Accepted", "Rejected", or "In Review".
Technical Stack
Frontend: [React.JS/shadcn/ui]
Backend: [Nest.js]
Database: [Postgres]

Local Setup

Clone the repository:
``` Bash
	git clone [repository-url]
	cd recruitment-webapp
```

Install dependencies:
``` Bash
	npm i
```

Add your installation command here
Configure environment variables:
Create a .env file based on .env.example.
Run the application:

``` Bash
npm run start
```

Development Workflow

This project follows SDD (Specification-Driven Development), BDD (Behavior-Driven Development), and TDD (Test-Driven Development).

- See /docs for architectural specifications.
- See /features for requirement definitions.
- See /tests for unit and integration tests.
- All development activity is logged in /prompts/prompt_log.md.

