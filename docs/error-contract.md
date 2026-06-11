# Error Contract & Response Specification

## Response Envelope Format

All API responses follow a consistent structure:

### Success Response (2xx)
```json
{
  "statusCode": 200,
  "data": { ... },
  "message": "Optional success message"
}
```

or for array responses:
```json
{
  "statusCode": 200,
  "data": [ ... ],
  "count": 10
}
```

### Error Response (4xx, 5xx)
```json
{
  "statusCode": 400,
  "error": "BadRequest",
  "message": "Human-readable error message",
  "details": {
    "field_name": ["error message 1", "error message 2"]
  },
  "timestamp": "2026-06-10T12:34:56Z"
}
```

---

## HTTP Status Codes & Error Types

### 400 Bad Request

Used for validation errors or malformed input.

**Scenarios:**
- Missing required field (name, email, phone, age, country, city, english_level, cv).
- Invalid field format (email not valid, age not a number, etc.).
- Age < 18.
- Empty or invalid file upload.
- Invalid UUID format in path parameter.

**Example Response:**
```json
{
  "statusCode": 400,
  "error": "BadRequest",
  "message": "Validation failed",
  "details": {
    "age": ["Age must be 18 or older."],
    "email": ["Email must be a valid email address."]
  },
  "timestamp": "2026-06-10T12:34:56Z"
}
```

---

### 404 Not Found

Used when a requested resource does not exist.

**Scenarios:**
- Candidate ID does not exist.
- CV file not found for a candidate.

**Example Response:**
```json
{
  "statusCode": 404,
  "error": "NotFound",
  "message": "Candidate with ID 550e8400-e29b-41d4-a716-446655440000 not found",
  "timestamp": "2026-06-10T12:34:56Z"
}
```

---

### 409 Conflict

Used when a unique constraint is violated.

**Scenarios:**
- Email already registered.

**Example Response:**
```json
{
  "statusCode": 409,
  "error": "Conflict",
  "message": "Email already registered",
  "details": {
    "email": ["Email 'john@example.com' is already in use. Please use a different email."]
  },
  "timestamp": "2026-06-10T12:34:56Z"
}
```

---

### 413 Payload Too Large

Used when uploaded file exceeds size limit.

**Scenarios:**
- CV file size > 5MB.

**Example Response:**
```json
{
  "statusCode": 413,
  "error": "PayloadTooLarge",
  "message": "CV file size must not exceed 5MB.",
  "details": {
    "cv": ["Uploaded file is 7.2 MB, but maximum allowed is 5 MB."]
  },
  "timestamp": "2026-06-10T12:34:56Z"
}
```

---

### 415 Unsupported Media Type

Used when uploaded file is not a valid PDF.

**Scenarios:**
- File is not a PDF (e.g., .txt, .doc, .jpg, etc.).

**Example Response:**
```json
{
  "statusCode": 415,
  "error": "UnsupportedMediaType",
  "message": "Invalid file format. Only PDF allowed.",
  "details": {
    "cv": ["File type 'text/plain' is not supported. Only 'application/pdf' is allowed."]
  },
  "timestamp": "2026-06-10T12:34:56Z"
}
```

---

### 500 Internal Server Error

Used for unexpected server errors.

**Scenarios:**
- Database connection failure.
- File system error when saving CV.
- Unhandled exception in service layer.

**Example Response:**
```json
{
  "statusCode": 500,
  "error": "InternalServerError",
  "message": "An unexpected error occurred. Please try again later.",
  "timestamp": "2026-06-10T12:34:56Z"
}
```

---

## Detailed Error Messages by Endpoint

### POST /api/v1/candidates (Register Candidate)

#### Error 400 - Missing CV
```json
{
  "statusCode": 400,
  "error": "BadRequest",
  "message": "Validation failed",
  "details": {
    "cv": ["CV is required."]
  }
}
```

#### Error 400 - Missing Required Field
```json
{
  "statusCode": 400,
  "error": "BadRequest",
  "message": "Validation failed",
  "details": {
    "name": ["Name is required and must not be empty."],
    "email": ["Email is required."],
    "phone": ["Phone is required."],
    "age": ["Age is required and must be a number."],
    "country": ["Country is required."],
    "city": ["City is required."],
    "english_level": ["English level is required and must be one of: A1, A2, B1, B2, C1, C2."]
  }
}
```

#### Error 400 - Invalid Age
```json
{
  "statusCode": 400,
  "error": "BadRequest",
  "message": "Validation failed",
  "details": {
    "age": ["Age must be 18 or older."]
  }
}
```

#### Error 409 - Duplicate Email
```json
{
  "statusCode": 409,
  "error": "Conflict",
  "message": "Email already registered",
  "details": {
    "email": ["Email 'john@example.com' is already in use."]
  }
}
```

#### Error 413 - File Size Exceeds Limit
```json
{
  "statusCode": 413,
  "error": "PayloadTooLarge",
  "message": "CV file size must not exceed 5MB.",
  "details": {
    "cv": ["File size 7.2 MB exceeds maximum allowed 5 MB."]
  }
}
```

#### Error 415 - Invalid File Format
```json
{
  "statusCode": 415,
  "error": "UnsupportedMediaType",
  "message": "Invalid file format. Only PDF allowed.",
  "details": {
    "cv": ["File type must be 'application/pdf', got 'text/plain'."]
  }
}
```

#### Success 201 - Candidate Registered
```json
{
  "statusCode": 201,
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+591 70000000",
    "age": 25,
    "country": "USA",
    "city": "New York",
    "english_level": "B2",
    "cv_url": "http://localhost:3000/api/v1/candidates/550e8400-e29b-41d4-a716-446655440000/cv",
    "status": "In Review",
    "createdAt": "2026-06-10T12:34:56Z"
  },
  "message": "Candidate registered successfully"
}
```

---

### GET /api/v1/candidates (List Candidates)

#### Success 200 - List Retrieved
```json
{
  "statusCode": 200,
  "data": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "+591 70000000",
      "age": 25,
      "country": "USA",
      "city": "New York",
      "english_level": "B2",
      "cv_url": "http://localhost:3000/api/v1/candidates/550e8400-e29b-41d4-a716-446655440000/cv",
      "status": "In Review",
      "createdAt": "2026-06-10T12:34:56Z"
    }
  ],
  "count": 1
}
```

---

### PATCH /api/v1/candidates/{id} (Update Status)

#### Error 400 - Invalid UUID
```json
{
  "statusCode": 400,
  "error": "BadRequest",
  "message": "Invalid candidate ID format",
  "details": {
    "id": ["ID must be a valid UUID."]
  }
}
```

#### Error 404 - Candidate Not Found
```json
{
  "statusCode": 404,
  "error": "NotFound",
  "message": "Candidate with ID 550e8400-e29b-41d4-a716-446655440000 not found"
}
```

#### Error 400 - Invalid Status
```json
{
  "statusCode": 400,
  "error": "BadRequest",
  "message": "Validation failed",
  "details": {
    "status": ["Status must be one of: In Review, Accepted, Rejected."]
  }
}
```

#### Success 200 - Status Updated
```json
{
  "statusCode": 200,
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+591 70000000",
    "age": 25,
    "country": "USA",
    "city": "New York",
    "english_level": "B2",
    "cv_url": "http://localhost:3000/api/v1/candidates/550e8400-e29b-41d4-a716-446655440000/cv",
    "status": "Accepted",
    "createdAt": "2026-06-10T12:34:56Z",
    "updatedAt": "2026-06-10T14:00:00Z"
  },
  "message": "Candidate status updated successfully"
}
```

---

### GET /api/v1/candidates/{id}/cv (Download CV)

#### Error 404 - Candidate or CV Not Found
```json
{
  "statusCode": 404,
  "error": "NotFound",
  "message": "CV not found for candidate 550e8400-e29b-41d4-a716-446655440000"
}
```

#### Success 200 - CV File Stream
- **Response Headers:**
  - `Content-Type: application/pdf`
  - `Content-Disposition: attachment; filename="john_doe_cv.pdf"`
  - `Content-Length: 256000` (size in bytes)
- **Response Body:** PDF file binary data.

---

## Error Handling Standards

1. **Consistent Format:** All errors follow the envelope format above.
2. **Field-Level Details:** Validation errors include specific field names and messages.
3. **HTTP Status Codes:** Follow REST conventions and semantic meaning.
4. **Timestamps:** All errors include ISO 8601 timestamp for debugging.
5. **Logging:** Server logs all 5xx errors with stack traces for debugging.
6. **Client Handling:** Frontend maps error codes to user-friendly messages.

---

## Common Error Messages

| Error Code | Message | Cause |
|-----------|---------|-------|
| 400 | Validation failed | Invalid input data |
| 400 | CV is required | Missing file upload |
| 400 | Age must be 18 or older | Underage candidate |
| 404 | Candidate not found | Invalid candidate ID |
| 409 | Email already registered | Duplicate email |
| 413 | CV file size must not exceed 5MB | File too large |
| 415 | Invalid file format. Only PDF allowed | Wrong file type |
| 500 | An unexpected error occurred | Server error |

---

## Implementation Notes

- Use NestJS exception filters to map business exceptions to HTTP responses.
- Use `class-validator` for DTO validation and automatic 400 responses.
- Log all errors with context (user, endpoint, timestamp) for debugging.
- Never expose sensitive information (database queries, stack traces) to client in production.
