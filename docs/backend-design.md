# Backend Design - NestJS Implementation

## Controller Layer

### CandidateController (`backend/src/infrastructure/controllers/candidate.controller.ts`)

#### Endpoints

##### POST /api/v1/candidates
- **Purpose:** Register a new candidate with CV upload.
- **Input:** `multipart/form-data` with fields:
  - `name` (string, required)
  - `email` (string, required, unique)
  - `phone` (string, required)
  - `age` (number, required, >= 18)
  - `country` (string, required)
  - `city` (string, required)
  - `english_level` (enum: A1, A2, B1, B2, C1, C2, required)
  - `cv` (file, required, PDF only, max 5MB)
- **Validation:** Use DTOs with `class-validator` decorators.
- **Success Response:** HTTP 201 with `Candidate` schema.
- **Error Responses:** HTTP 400, 409, 413, 415 per `docs/error-contract.md`.

##### GET /api/v1/candidates
- **Purpose:** Retrieve all candidates with optional filters.
- **Query Parameters:**
  - `country` (optional, string)
  - `english_level` (optional, enum)
  - `status` (optional, enum: Accepted, Rejected, In Review)
- **Success Response:** HTTP 200 with array of `Candidate` objects.
- **Sorting:** By `createdAt` DESC (most recent first).

##### PATCH /api/v1/candidates/{id}
- **Purpose:** Update candidate application status.
- **Path Parameter:** `id` (UUID)
- **Input Body:**
  ```json
  {
    "status": "Accepted|Rejected|In Review"
  }
  ```
- **Success Response:** HTTP 200 with updated `Candidate`.
- **Error Responses:** HTTP 400, 404.

##### GET /api/v1/candidates/{id}/cv
- **Purpose:** Download or stream the candidate's CV file.
- **Path Parameter:** `id` (UUID)
- **Success Response:** HTTP 200 with PDF file stream, `Content-Type: application/pdf`.
- **Error Response:** HTTP 404 if candidate or file not found.

---

## Core Layer (Use Cases / Services)

### CandidateService (`backend/src/core/services/candidate.service.ts`)

#### Methods

##### `register(dto: CreateCandidateDto, cvFile: Express.Multer.File): Promise<Candidate>`
- Validates input against domain rules (age >= 18, unique email, PDF format, size limit).
- Calls `FileStorageService.store()` to save CV to `cv_files/`.
- Receives `cv_path` (relative path or URL).
- Creates `Candidate` entity with `cv_path`.
- Calls `CandidateRepository.save()` to persist.
- Returns saved `Candidate` with `cv_url` (full URL).

##### `list(filters?: CandidateFilters): Promise<Candidate[]>`
- Calls `CandidateRepository.findAll(filters)`.
- Filters by country, english_level, and status if provided.
- Returns candidates sorted by `createdAt` DESC.

##### `updateStatus(id: UUID, status: ApplicationStatus): Promise<Candidate>`
- Validates UUID format.
- Calls `CandidateRepository.findById(id)`.
- Throws 404 if not found.
- Updates `status` field.
- Calls `CandidateRepository.save()`.
- Returns updated `Candidate`.

---

## Repository Layer

### CandidateRepository (Abstract Contract)

#### Interface (`backend/src/core/repositories/candidate.repository.ts`)
```typescript
export interface ICandidateRepository {
  save(candidate: Candidate): Promise<Candidate>;
  findById(id: UUID): Promise<Candidate | null>;
  findByEmail(email: string): Promise<Candidate | null>;
  findAll(filters?: CandidateFilters): Promise<Candidate[]>;
  update(id: UUID, updates: Partial<Candidate>): Promise<Candidate>;
}
```

### TypeOrmCandidateRepository (Concrete Implementation)

#### Implementation (`backend/src/infrastructure/repositories/typeorm-candidate.repository.ts`)
- Uses TypeORM `CandidateEntity` to map to database.
- Implements all `ICandidateRepository` methods.
- Handles SQL queries: SELECT, INSERT, UPDATE.
- Applies filters in `findAll()`: country, english_level, status.
- Orders by `createdAt DESC`.

---

## File Storage Service

### FileStorageService (`backend/src/infrastructure/services/file-storage.service.ts`)

#### Methods

##### `store(file: Express.Multer.File): Promise<string>`
- Validates file is PDF (check MIME type and extension).
- Validates file size <= 5MB.
- Generates safe filename: `{uuid}_{timestamp}_{sanitized_original_name}.pdf`.
- Saves file to `cv_files/` directory in project root or configured storage path.
- Returns relative path: `cv_files/{filename}`.

##### `retrieve(filePath: string): Promise<Buffer>`
- Reads file from `cv_files/{filename}`.
- Returns file buffer.
- Throws error if file not found.

##### `delete(filePath: string): Promise<void>`
- Removes file from `cv_files/`.
- Used if candidate registration fails or record is deleted.

---

## Entity & Value Objects

### Candidate Entity (`backend/src/core/entities/candidate.entity.ts`)
```typescript
export class Candidate {
  id: UUID;
  name: string;
  email: string;
  phone: string;
  age: number; // validation: >= 18
  country: string;
  city: string;
  english_level: EnglishLevel;
  cv_path: string; // relative path in cv_files/
  status: ApplicationStatus; // default: In Review
  createdAt: DateTime;
  updatedAt?: DateTime;
}
```

### EnglishLevel (Value Object / Enum)
Values: `A1`, `A2`, `B1`, `B2`, `C1`, `C2`.

### ApplicationStatus (Value Object / Enum)
Values: `Accepted`, `Rejected`, `In Review`.

---

## Data Transfer Objects (DTOs)

### CreateCandidateDto (`backend/src/infrastructure/dtos/create-candidate.dto.ts`)
- `name` (string, minLength 1, maxLength 255)
- `email` (string, email format, required)
- `phone` (string, required)
- `age` (number, min 18, required)
- `country` (string, required)
- `city` (string, required)
- `english_level` (enum, required)
- `cv` (file, attached via multipart)

### CandidateResponseDto
- Returns candidate with `cv_url` (full URL to `/api/v1/candidates/{id}/cv`).
- Excludes internal paths.

### UpdateCandidateStatusDto
- `status` (enum, required)

---

## Database Integration

### TypeORM Entity (`backend/src/infrastructure/database/entities/candidate.entity.ts`)
- Maps to table `candidates`.
- Columns:
  - `id` (UUID, primary key)
  - `name` (VARCHAR 255)
  - `email` (VARCHAR 255, unique index)
  - `phone` (VARCHAR 50)
  - `age` (INTEGER)
  - `country` (VARCHAR 100)
  - `city` (VARCHAR 100)
  - `english_level` (VARCHAR 10, enum)
  - `cv_path` (VARCHAR 2048)
  - `status` (VARCHAR 50, enum, default "In Review")
  - `createdAt` (TIMESTAMP, default current_timestamp)
  - `updatedAt` (TIMESTAMP, nullable)

---

## File Handling Workflow

1. Client sends `POST /candidates` with multipart form + PDF file.
2. Controller receives request and validates DTO.
3. Controller calls `CandidateService.register(dto, file)`.
4. Service calls `FileStorageService.store(file)`.
5. FileStorageService saves PDF to `cv_files/{safe_name}.pdf`, returns path.
6. Service creates `Candidate` entity with `cv_path`.
7. Service calls `CandidateRepository.save(candidate)`.
8. Repository persists to database and returns saved entity.
9. Service builds `cv_url` as `http://host/api/v1/candidates/{id}/cv`.
10. Controller returns HTTP 201 with candidate and `cv_url`.

---

## Error Handling

- All errors are caught and mapped to HTTP status codes per `docs/error-contract.md`.
- File validation errors return HTTP 415 (Unsupported Media Type) or 413 (Payload Too Large).
- Duplicate email returns HTTP 409 (Conflict).
- Invalid data returns HTTP 400 (Bad Request) with field-level error details.
- Not found returns HTTP 404.
