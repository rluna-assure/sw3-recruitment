# Validation Rules

This document specifies concrete validation constraints for Recruitment WebApp. Implement these checks at the API boundary (request validation) and enforce critical constraints at the persistence layer.

## Field Constraints

- `name`:
  - Type: string
  - Required: yes
  - Max length: 100 characters
  - Example error: `"Name must be at most 100 characters."`

- `email`:
  - Type: string (email)
  - Required: yes
  - Max length: 254 characters (RFC limit)
  - Unique: yes (DB unique index)
  - Normalization: lowercase, trimmed
  - Example error: `"Email is invalid or already registered."`

- `phone`:
  - Type: string
  - Required: yes
  - Max length: 20 characters
  - Allowed characters: digits, spaces, +, -, ()
  - Example error: `"Phone number is invalid."`

- `age`:
  - Type: integer
  - Required: yes
  - Min: 18
  - Example error: `"Age must be 18 or older."`

- `country`:
  - Type: string
  - Required: yes
  - Max length: 56 characters
  - Example error: `"Country is required."`

- `city`:
  - Type: string
  - Required: yes
  - Max length: 100 characters
  - Example error: `"City is required."`

- `english_level`:
  - Type: enum
  - Required: yes
  - Allowed values: `A1`, `A2`, `B1`, `B2`, `C1`, `C2`
  - Example error: `"Invalid english_level. Allowed values: A1,A2,B1,B2,C1,C2."`

- `cv` (file upload):
  - Required: yes
  - Type: PDF only (`application/pdf`)
  - Max size: 5 MB
  - Sanitize filename; store using generated identifiers
  - Example errors:
    - `"CV is required."`
    - `"Invalid file format. Only PDF allowed."`
    - `"CV file size must not exceed 5MB."`

- `status` (PATCH body):
  - Type: enum
  - Required for PATCH: yes
  - Allowed values: `Accepted`, `Rejected`, `In Review`
  - Example error: `"Invalid status value."`

## Request & Parameter Validation

- Reject unknown fields in request payloads (400 Bad Request).
- Validate path parameters (e.g., `id`) as UUID (return 400 if invalid format).
- Validate query parameters for filters and pagination (`page`, `limit`, `sort`).

## Persistence Constraints

- Enforce `email` uniqueness at DB-level with a unique index; handle unique-constraint violations gracefully.
- Use appropriate column lengths matching the API limits to avoid truncation.
- Store `cv_path`/`cv_url` with sufficient length (e.g., VARCHAR 2048).

## Security & Safety

- Sanitize file names and prevent path traversal.
- Validate MIME type and file signature if possible.
- (Optional) integrate virus scanning for file uploads.
- Use parameterized queries/ORM to avoid injection.

## Error Response Format (JSON)

- Validation error example (400):

  {
    "statusCode": 400,
    "error": "Bad Request",
    "message": "Validation failed: age must be 18 or older.",
    "details": [
      { "field": "age", "message": "Age must be 18 or older." }
    ]
  }

- Unique constraint example (409):

  {
    "statusCode": 409,
    "error": "Conflict",
    "message": "Email already registered.",
    "details": [
      { "field": "email", "message": "Email already registered." }
    ]
  }

 - Unsupported media type example (415):

   {
     "statusCode": 415,
     "error": "Unsupported Media Type",
     "message": "Invalid file format. Only PDF allowed."
   }

 - File too large example (413):

   {
     "statusCode": 413,
     "error": "Payload Too Large",
     "message": "CV file size must not exceed 5MB."
   }

Notes:
- Prefer returning a `details` array with per-field messages for clients to display inline errors.
- Use HTTP 400 for generic validation errors, 409 for uniqueness conflicts, 415 for unsupported media types, and 413 for oversized payloads when appropriate.

## Concurrency Notes

- To prevent duplicate-email race conditions, rely on DB unique index + catch constraint errors and return a 409 Conflict.

## Implementation Hints

- Use `class-validator` / `class-transformer` (NestJS) or similar to express rules.
- Centralize validation error formatting in a shared error handler.
- Keep client-facing messages user-friendly and avoid leaking internal details.
