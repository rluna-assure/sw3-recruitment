# Database Schema

## Overview

The Recruitment WebApp uses **PostgreSQL** as the primary database. The schema follows the domain model defined in `docs/diagrams/data-model.md` and supports the API contracts in `docs/api_spec.yaml`.

---

## Tables

### candidates

Stores candidate registration data and application status.

**Table Name:** `candidates`

**Columns:**

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique identifier for candidate |
| `name` | VARCHAR(255) | NOT NULL | Candidate full name |
| `email` | VARCHAR(255) | NOT NULL, UNIQUE | Email address, must be unique |
| `phone` | VARCHAR(50) | NOT NULL | Phone number |
| `age` | INTEGER | NOT NULL, CHECK (age >= 18) | Age, must be 18 or older |
| `country` | VARCHAR(100) | NOT NULL | Country of residence |
| `city` | VARCHAR(100) | NOT NULL | City of residence |
| `english_level` | VARCHAR(10) | NOT NULL | Enum: A1, A2, B1, B2, C1, C2 |
| `cv_path` | VARCHAR(2048) | NOT NULL | Relative path to CV in `cv_files/` (e.g., `cv_files/550e8400-e29b-41d4-a716-446655440000_1686000000000_john_doe.pdf`) |
| `status` | VARCHAR(50) | NOT NULL, DEFAULT 'In Review' | Enum: In Review, Accepted, Rejected |
| `createdAt` | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Timestamp when candidate was registered |
| `updatedAt` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Timestamp of last update |

**Indexes:**

- `PRIMARY KEY (id)` — Fast lookup by candidate ID.
- `UNIQUE (email)` — Enforce unique email constraint and fast duplicate checks.
- `INDEX (country)` — Fast filtering by country.
- `INDEX (english_level)` — Fast filtering by English level.
- `INDEX (status)` — Fast filtering by status.
- `INDEX (createdAt DESC)` — Support sorting by most recent.

**Example Row:**


```
id| name| email| phone| age | country | city| english_level | cv_path| status     | createdAt| updatedAt
550e8400-e29b-41d4-a716-446655440000  | John Doe   | john@example.com  | +591 70000000 | 25  | USA     | New York  | B2            | cv_files/550e8400-e29b-41d4-a716-446655440000_1686000000000_john_doe.pdf | In Review  | 2026-06-10 12:34:56 | 2026-06-10 12:34:56
```


---

## Enums (PostgreSQL ENUM types)

### english_level_enum

```sql
CREATE TYPE english_level_enum AS ENUM ('A1', 'A2', 'B1', 'B2', 'C1', 'C2');
```

Used in `candidates.english_level` column.

### application_status_enum

```sql
CREATE TYPE application_status_enum AS ENUM ('In Review', 'Accepted', 'Rejected');
```

Used in `candidates.status` column.

---

## SQL Creation Script

```sql
-- Create enums
CREATE TYPE english_level_enum AS ENUM ('A1', 'A2', 'B1', 'B2', 'C1', 'C2');
CREATE TYPE application_status_enum AS ENUM ('In Review', 'Accepted', 'Rejected');

-- Create candidates table
CREATE TABLE candidates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(50) NOT NULL,
  age INTEGER NOT NULL CHECK (age >= 18),
  country VARCHAR(100) NOT NULL,
  city VARCHAR(100) NOT NULL,
  english_level english_level_enum NOT NULL,
  cv_path VARCHAR(2048) NOT NULL,
  status application_status_enum NOT NULL DEFAULT 'In Review',
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_candidates_country ON candidates(country);
CREATE INDEX idx_candidates_english_level ON candidates(english_level);
CREATE INDEX idx_candidates_status ON candidates(status);
CREATE INDEX idx_candidates_createdAt ON candidates(createdAt DESC);
CREATE UNIQUE INDEX idx_candidates_email ON candidates(email);

-- Create trigger for updatedAt (optional, auto-updates timestamp)
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updatedAt = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_timestamp
BEFORE UPDATE ON candidates
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();
```

---

## Data Validation Rules (at DB level)

1. **Age Constraint:** `CHECK (age >= 18)` — Prevents invalid ages.
2. **Email Uniqueness:** `UNIQUE (email)` — Ensures no duplicate registrations.
3. **Enum Constraints:** PostgreSQL enforces valid enum values automatically.
4. **NOT NULL:** All core fields are NOT NULL to ensure data integrity.

---

## Relationships

Currently, there are no foreign key relationships. The schema is simplified for MVP:

- No separate users/admin table (MVP uses route-based access).
- No audit log (can be added later).
- No application history (only current status is stored).

For future extensions:
- Add `admin_users` table with authentication.
- Add `audit_log` table for status change history.
- Add `email_templates` table for notifications.

---

## Backup & Recovery

- **Backup Strategy:** Daily automated backups of PostgreSQL database.
- **Retention:** Keep 30 days of backups.
- **Recovery:** Point-in-time recovery up to 7 days.

---

## Migration Management

- Use **TypeORM migrations** or **Flyway** for schema versioning.
- Each migration file should be timestamped and reversible.
- Example migration file:
  ```
  src/infrastructure/database/migrations/1686000000000-CreateCandidatesTable.ts
  ```

---

## Performance Considerations

- **Indexes on Filters:** All filter columns (country, english_level, status) are indexed for fast queries.
- **Sorting:** `createdAt DESC` index supports default sort order.
- **Email Lookup:** Unique index on email enables fast duplicate checks during registration.
- **Pagination:** Consider adding LIMIT and OFFSET for large result sets (currently returns all).

---

## Example Queries

### Register a candidate
```sql
INSERT INTO candidates (name, email, phone, age, country, city, english_level, cv_path, status)
VALUES ('John Doe', 'john@example.com', '+591 70000000', 25, 'USA', 'New York', 'B2', 'cv_files/550e8400-e29b-41d4-a716-446655440000_1686000000000_john_doe.pdf', 'In Review');
```

### List all candidates with filters
```sql
SELECT * FROM candidates
WHERE country = 'USA'
  AND english_level = 'B2'
  AND status = 'In Review'
ORDER BY createdAt DESC;
```

### Update candidate status
```sql
UPDATE candidates
SET status = 'Accepted', updatedAt = CURRENT_TIMESTAMP
WHERE id = '550e8400-e29b-41d4-a716-446655440000';
```

### Check for duplicate email
```sql
SELECT COUNT(*) FROM candidates WHERE email = 'john@example.com';
```

---

## Future Enhancements

- Partition table by country or date range for large datasets.
- Add full-text search index on name for candidate search.
- Archive old candidates to separate table.
- Add soft delete column (deleted_at) for GDPR compliance.
