# Test Specifications & Strategy

## Test Pyramid

```
 Unit Tests (90%) Functions, Classes, Isolated
```

---

## Test Organization

```
tests/
  unit/
    services/
      candidate.service.spec.ts
      file-storage.service.spec.ts
    repositories/
      typeorm-candidate.repository.spec.ts
    entities/
      candidate.entity.spec.ts
    dtos/
      create-candidate.dto.spec.ts
  integration/
    controllers/
      candidate.controller.spec.ts
    e2e/
      candidate-registration.e2e.spec.ts
      candidate-list.e2e.spec.ts
      candidate-status-update.e2e.spec.ts
      admin-panel.e2e.spec.ts
  frontend/
    components/
      RegistrationForm.test.tsx
      CandidateTable.test.tsx
      FilterBar.test.tsx
    pages/
      RegistrationPage.test.tsx
      AdminPanel.test.tsx
    services/
      candidateService.test.ts
    utils/
      trafficLightCalculator.test.ts
```

---

## Backend Unit Tests

### CandidateService Tests (`tests/src/services/candidate.service.spec.ts`)

#### Test Suite: register(dto, cvFile)

```typescript
describe('CandidateService.register()', () => {
  
  it('should register a valid candidate with valid CV', async () => {
    // Arrange
    const dto = { name: 'John Doe', email: 'john@example.com', ... };
    const cvFile = { originalname: 'cv.pdf', size: 1024000, ... };
    // Mock FileStorageService.store() to return cv_path
    // Mock CandidateRepository.save() to return saved candidate
    
    // Act
    const result = await service.register(dto, cvFile);
    
    // Assert
    expect(result.id).toBeDefined();
    expect(result.cv_path).toContain('cv_files/');
    expect(result.status).toBe('In Review');
  });

  it('should reject candidate with age < 18', async () => {
    // Arrange
    const dto = { ...validDto, age: 17 };
    const cvFile = validCvFile;
    
    // Act & Assert
    await expect(service.register(dto, cvFile))
      .rejects.toThrow('Age must be 18 or older');
  });

  it('should reject candidate with duplicate email', async () => {
    // Arrange
    const dto = { ...validDto, email: 'existing@example.com' };
    // Mock CandidateRepository.findByEmail() to return existing candidate
    
    // Act & Assert
    await expect(service.register(dto, cvFile))
      .rejects.toThrow('Email already registered');
  });

  it('should reject candidate with missing CV', async () => {
    // Act & Assert
    await expect(service.register(validDto, null))
      .rejects.toThrow('CV is required');
  });

  it('should reject CV file larger than 5MB', async () => {
    // Arrange
    const largeFile = { size: 6 * 1024 * 1024, ... };
    
    // Act & Assert
    await expect(service.register(validDto, largeFile))
      .rejects.toThrow('CV file size must not exceed 5MB');
  });

  it('should reject CV that is not PDF', async () => {
    // Arrange
    const textFile = { mimetype: 'text/plain', originalname: 'document.txt', ... };
    
    // Act & Assert
    await expect(service.register(validDto, textFile))
      .rejects.toThrow('Invalid file format. Only PDF allowed');
  });
});
```

#### Test Suite: list(filters)

```typescript
describe('CandidateService.list()', () => {
  
  it('should return all candidates if no filters', async () => {
    // Arrange
    const candidates = [candidate1, candidate2, candidate3];
    // Mock CandidateRepository.findAll(undefined) to return candidates
    
    // Act
    const result = await service.list();
    
    // Assert
    expect(result.length).toBe(3);
    expect(result[0].createdAt >= result[1].createdAt).toBe(true); // sorted DESC
  });

  it('should filter candidates by country', async () => {
    // Arrange
    const filters = { country: 'USA' };
    // Mock CandidateRepository.findAll(filters) to return USA candidates
    
    // Act
    const result = await service.list(filters);
    
    // Assert
    expect(result.every(c => c.country === 'USA')).toBe(true);
  });

  it('should filter candidates by english_level', async () => {
    // Arrange
    const filters = { english_level: 'B2' };
    
    // Act
    const result = await service.list(filters);
    
    // Assert
    expect(result.every(c => c.english_level === 'B2')).toBe(true);
  });

  it('should filter candidates by status', async () => {
    // Arrange
    const filters = { status: 'Accepted' };
    
    // Act
    const result = await service.list(filters);
    
    // Assert
    expect(result.every(c => c.status === 'Accepted')).toBe(true);
  });

  it('should combine multiple filters', async () => {
    // Arrange
    const filters = { country: 'USA', english_level: 'B2', status: 'In Review' };
    
    // Act
    const result = await service.list(filters);
    
    // Assert
    expect(result.every(c => 
      c.country === 'USA' && c.english_level === 'B2' && c.status === 'In Review'
    )).toBe(true);
  });

  it('should return sorted by createdAt DESC', async () => {
    // Arrange
    const candidates = [
      { ...candidate1, createdAt: '2026-06-01' },
      { ...candidate2, createdAt: '2026-06-10' },
      { ...candidate3, createdAt: '2026-06-05' }
    ];
    
    // Act
    const result = await service.list();
    
    // Assert
    expect(result[0].createdAt).toBe('2026-06-10'); // most recent
    expect(result[1].createdAt).toBe('2026-06-05');
    expect(result[2].createdAt).toBe('2026-06-01');
  });
});
```

#### Test Suite: updateStatus(id, status)

```typescript
describe('CandidateService.updateStatus()', () => {
  
  it('should update candidate status to Accepted', async () => {
    // Arrange
    const id = 'valid-uuid';
    // Mock CandidateRepository.findById() to return candidate
    // Mock CandidateRepository.update() to return updated candidate
    
    // Act
    const result = await service.updateStatus(id, 'Accepted');
    
    // Assert
    expect(result.status).toBe('Accepted');
  });

  it('should throw 404 if candidate not found', async () => {
    // Arrange
    const id = 'non-existent-uuid';
    // Mock CandidateRepository.findById() to return null
    
    // Act & Assert
    await expect(service.updateStatus(id, 'Rejected'))
      .rejects.toThrow('Candidate not found');
  });

  it('should reject invalid status value', async () => {
    // Act & Assert
    await expect(service.updateStatus(validId, 'Invalid'))
      .rejects.toThrow('Status must be one of: In Review, Accepted, Rejected');
  });

  it('should reject invalid UUID format', async () => {
    // Act & Assert
    await expect(service.updateStatus('not-a-uuid', 'Accepted'))
      .rejects.toThrow('Invalid UUID format');
  });
});
```

### FileStorageService Tests (`tests/src/infrastructure/services/file-storage.service.spec.ts`)

```typescript
describe('FileStorageService', () => {
  
  it('should store valid PDF file and return path', async () => {
    // Arrange
    const file = { 
      originalname: 'john_doe.pdf',
      mimetype: 'application/pdf',
      size: 1024000,
      buffer: Buffer.from([...])
    };
    
    // Act
    const result = await service.store(file);
    
    // Assert
    expect(result).toMatch(/cv_files\/[a-f0-9-]+_\d+_john_doe\.pdf/);
  });

  it('should reject file larger than 5MB', async () => {
    const largeFile = { size: 6 * 1024 * 1024, ... };
    
    await expect(service.store(largeFile))
      .rejects.toThrow('CV file size must not exceed 5MB');
  });

  it('should reject non-PDF file', async () => {
    const textFile = { mimetype: 'text/plain', ... };
    
    await expect(service.store(textFile))
      .rejects.toThrow('Invalid file format. Only PDF allowed');
  });

  it('should sanitize filename', async () => {
    const file = { 
      originalname: '../../malicious/file.pdf',
      mimetype: 'application/pdf',
      size: 1024000
    };
    
    const result = await service.store(file);
    
    // Assert filename doesn't contain path traversal
    expect(result).not.toContain('..');
  });

  it('should retrieve stored file by path', async () => {
    // Arrange
    const path = 'cv_files/uuid_timestamp_name.pdf';
    
    // Act
    const buffer = await service.retrieve(path);
    
    // Assert
    expect(buffer).toBeInstanceOf(Buffer);
  });

  it('should throw error if file not found', async () => {
    await expect(service.retrieve('cv_files/nonexistent.pdf'))
      .rejects.toThrow('File not found');
  });

  it('should delete file from storage', async () => {
    // Arrange
    const path = 'cv_files/uuid_timestamp_name.pdf';
    
    // Act
    await service.delete(path);
    
    // Assert
    await expect(service.retrieve(path))
      .rejects.toThrow('File not found');
  });
});
```

### CandidateEntity Validation Tests

```typescript
describe('Candidate Entity Validation', () => {
  
  it('should create valid candidate', () => {
    const candidate = new Candidate({
      name: 'John Doe',
      email: 'john@example.com',
      age: 25,
      ...
    });
    
    expect(candidate.isValid()).toBe(true);
  });

  it('should reject age < 18', () => {
    const candidate = new Candidate({ ...validData, age: 17 });
    
    expect(candidate.isValid()).toBe(false);
    expect(candidate.errors).toContain('Age must be 18 or older');
  });

  it('should validate email format', () => {
    const candidate = new Candidate({ ...validData, email: 'invalid-email' });
    
    expect(candidate.isValid()).toBe(false);
  });

  it('should set default status to In Review', () => {
    const candidate = new Candidate(validData);
    
    expect(candidate.status).toBe('In Review');
  });
});
```

---

## Backend Integration Tests

### CandidateController Tests (`tests/integration/controllers/candidate.controller.spec.ts`)

```typescript
describe('CandidateController (Integration)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture = await Test.createTestingModule({
      imports: [AppModule]
    }).compile();
    
    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('POST /api/v1/candidates', () => {
    
    it('should register candidate successfully', () => {
      return request(app.getHttpServer())
        .post('/api/v1/candidates')
        .field('name', 'John Doe')
        .field('email', 'john@example.com')
        .field('age', 25)
        .field('country', 'USA')
        .field('city', 'New York')
        .field('english_level', 'B2')
        .field('phone', '+1 555 123 4567')
        .attach('cv', 'test-files/valid-cv.pdf')
        .expect(201)
        .expect(res => {
          expect(res.body.data.id).toBeDefined();
          expect(res.body.data.cv_url).toBeDefined();
          expect(res.body.data.status).toBe('In Review');
        });
    });

    it('should reject missing required field', () => {
      return request(app.getHttpServer())
        .post('/api/v1/candidates')
        .field('name', 'John Doe')
        // missing email, age, etc.
        .expect(400)
        .expect(res => {
          expect(res.body.details).toHaveProperty('email');
        });
    });

    it('should reject file size > 5MB', () => {
      return request(app.getHttpServer())
        .post('/api/v1/candidates')
        .field('name', 'John Doe')
        .field('email', 'john@example.com')
        .field('age', 25)
        .field('country', 'USA')
        .field('city', 'New York')
        .field('english_level', 'B2')
        .field('phone', '+1 555 123 4567')
        .attach('cv', 'test-files/large-cv-6mb.pdf')
        .expect(413)
        .expect(res => {
          expect(res.body.message).toContain('5MB');
        });
    });

    it('should reject non-PDF file', () => {
      return request(app.getHttpServer())
        .post('/api/v1/candidates')
        .field('name', 'John Doe')
        .field('email', 'john@example.com')
        ...
        .attach('cv', 'test-files/document.txt')
        .expect(415)
        .expect(res => {
          expect(res.body.message).toContain('PDF');
        });
    });

    it('should reject duplicate email', async () => {
      // First registration
      await request(app.getHttpServer())
        .post('/api/v1/candidates')
        .field('email', 'john@example.com')
        ...;
      
      // Second registration with same email
      return request(app.getHttpServer())
        .post('/api/v1/candidates')
        .field('email', 'john@example.com')
        ...
        .expect(409)
        .expect(res => {
          expect(res.body.message).toContain('Email already registered');
        });
    });
  });

  describe('GET /api/v1/candidates', () => {
    
    it('should list all candidates', () => {
      return request(app.getHttpServer())
        .get('/api/v1/candidates')
        .expect(200)
        .expect(res => {
          expect(Array.isArray(res.body.data)).toBe(true);
          expect(res.body.count).toBeGreaterThanOrEqual(0);
        });
    });

    it('should filter by country', () => {
      return request(app.getHttpServer())
        .get('/api/v1/candidates?country=USA')
        .expect(200)
        .expect(res => {
          expect(res.body.data.every(c => c.country === 'USA')).toBe(true);
        });
    });

    it('should filter by english_level', () => {
      return request(app.getHttpServer())
        .get('/api/v1/candidates?english_level=B2')
        .expect(200)
        .expect(res => {
          expect(res.body.data.every(c => c.english_level === 'B2')).toBe(true);
        });
    });
  });

  describe('PATCH /api/v1/candidates/{id}', () => {
    
    it('should update candidate status', async () => {
      // Create candidate first
      const createRes = await request(app.getHttpServer())
        .post('/api/v1/candidates')
        ...;
      const candidateId = createRes.body.data.id;
      
      // Update status
      return request(app.getHttpServer())
        .patch(`/api/v1/candidates/${candidateId}`)
        .send({ status: 'Accepted' })
        .expect(200)
        .expect(res => {
          expect(res.body.data.status).toBe('Accepted');
        });
    });

    it('should reject invalid status', () => {
      return request(app.getHttpServer())
        .patch(`/api/v1/candidates/valid-uuid`)
        .send({ status: 'InvalidStatus' })
        .expect(400);
    });

    it('should return 404 for non-existent candidate', () => {
      return request(app.getHttpServer())
        .patch('/api/v1/candidates/00000000-0000-0000-0000-000000000000')
        .send({ status: 'Accepted' })
        .expect(404);
    });
  });

  describe('GET /api/v1/candidates/{id}/cv', () => {
    
    it('should download CV file', async () => {
      // Create candidate first and get ID
      const candidateId = '...';
      
      return request(app.getHttpServer())
        .get(`/api/v1/candidates/${candidateId}/cv`)
        .expect(200)
        .expect('Content-Type', 'application/pdf')
        .expect(res => {
          expect(res.body.length).toBeGreaterThan(0);
        });
    });

    it('should return 404 if CV not found', () => {
      return request(app.getHttpServer())
        .get('/api/v1/candidates/00000000-0000-0000-0000-000000000000/cv')
        .expect(404);
    });
  });
});
```

---

## Frontend Unit Tests

### RegistrationForm Component Tests

```typescript
describe('RegistrationForm', () => {
  
  it('should render form with all fields', () => {
    const { getByLabelText } = render(<RegistrationForm />);
    
    expect(getByLabelText(/Name/i)).toBeInTheDocument();
    expect(getByLabelText(/Email/i)).toBeInTheDocument();
    expect(getByLabelText(/Age/i)).toBeInTheDocument();
    expect(getByLabelText(/CV/i)).toBeInTheDocument();
  });

  it('should validate age >= 18', async () => {
    const { getByLabelText, getByText } = render(<RegistrationForm />);
    
    fireEvent.change(getByLabelText(/Age/i), { target: { value: '17' } });
    fireEvent.click(getByText(/Submit/i));
    
    await waitFor(() => {
      expect(getByText(/Age must be 18/i)).toBeInTheDocument();
    });
  });

  it('should validate email format', async () => {
    const { getByLabelText, getByText } = render(<RegistrationForm />);
    
    fireEvent.change(getByLabelText(/Email/i), { target: { value: 'invalid' } });
    fireEvent.click(getByText(/Submit/i));
    
    await waitFor(() => {
      expect(getByText(/valid email/i)).toBeInTheDocument();
    });
  });

  it('should warn if CV file is too large', () => {
    const { getByLabelText } = render(<RegistrationForm />);
    
    const largeFile = new File(['x'.repeat(6 * 1024 * 1024)], 'large.pdf', { type: 'application/pdf' });
    fireEvent.change(getByLabelText(/CV/i), { target: { files: [largeFile] } });
    
    expect(screen.getByText(/exceeds 5MB/i)).toBeInTheDocument();
  });

  it('should submit form with valid data', async () => {
    const onSuccess = jest.fn();
    const { getByLabelText, getByText } = render(<RegistrationForm onSuccess={onSuccess} />);
    
    // Fill form
    fireEvent.change(getByLabelText(/Name/i), { target: { value: 'John Doe' } });
    fireEvent.change(getByLabelText(/Email/i), { target: { value: 'john@example.com' } });
    fireEvent.change(getByLabelText(/Age/i), { target: { value: '25' } });
    fireEvent.change(getByLabelText(/CV/i), { target: { files: [validPdfFile] } });
    
    // Submit
    fireEvent.click(getByText(/Submit/i));
    
    await waitFor(() => {
      expect(onSuccess).toHaveBeenCalled();
    });
  });

  it('should display server error message', async () => {
    const { getByText } = render(<RegistrationForm />);
    
    // Mock API error
    // Trigger submission
    // Check error is displayed
  });
});
```

### CandidateTable Component Tests

```typescript
describe('CandidateTable', () => {
  
  it('should render table with candidate data', () => {
    const candidates = [
      { id: '1', name: 'John Doe', country: 'USA', english_level: 'B2', ... },
      { id: '2', name: 'Jane Smith', country: 'Bolivia', english_level: 'C1', ... }
    ];
    
    const { getByText } = render(<CandidateTable candidates={candidates} />);
    
    expect(getByText('John Doe')).toBeInTheDocument();
    expect(getByText('Jane Smith')).toBeInTheDocument();
  });

  it('should display traffic light colors', () => {
    const candidates = [
      { english_level: 'C1', ... }, // green
      { english_level: 'B1', ... }, // yellow
      { english_level: 'A1', ... }  // red
    ];
    
    const { container } = render(<CandidateTable candidates={candidates} />);
    
    expect(container.querySelector('.traffic-light-green')).toBeInTheDocument();
    expect(container.querySelector('.traffic-light-yellow')).toBeInTheDocument();
    expect(container.querySelector('.traffic-light-red')).toBeInTheDocument();
  });

  it('should call onStatusUpdate when status button clicked', () => {
    const onStatusUpdate = jest.fn();
    const candidate = { id: '1', name: 'John Doe', status: 'In Review', ... };
    
    const { getByText } = render(
      <CandidateTable candidates={[candidate]} onStatusUpdate={onStatusUpdate} />
    );
    
    fireEvent.click(getByText(/Accept/i));
    
    expect(onStatusUpdate).toHaveBeenCalledWith('1', 'Accepted');
  });

  it('should sort by createdAt DESC', () => {
    const candidates = [
      { id: '1', name: 'Alice', createdAt: '2026-06-01', ... },
      { id: '2', name: 'Bob', createdAt: '2026-06-10', ... },
      { id: '3', name: 'Charlie', createdAt: '2026-06-05', ... }
    ];
    
    const { container } = render(<CandidateTable candidates={candidates} />);
    const rows = container.querySelectorAll('tbody tr');
    
    expect(rows[0]).toHaveTextContent('Bob'); // most recent
    expect(rows[1]).toHaveTextContent('Charlie');
    expect(rows[2]).toHaveTextContent('Alice');
  });
});
```

### TrafficLightCalculator Utility Tests

```typescript
describe('trafficLightCalculator', () => {
  
  it('should return green for C1', () => {
    expect(getTrafficLight('C1')).toBe('green');
  });

  it('should return green for C2', () => {
    expect(getTrafficLight('C2')).toBe('green');
  });

  it('should return yellow for B1', () => {
    expect(getTrafficLight('B1')).toBe('yellow');
  });

  it('should return yellow for B2', () => {
    expect(getTrafficLight('B2')).toBe('yellow');
  });

  it('should return red for A1', () => {
    expect(getTrafficLight('A1')).toBe('red');
  });

  it('should return red for A2', () => {
    expect(getTrafficLight('A2')).toBe('red');
  });
});
```

---

## Backend E2E Tests

### Candidate Registration Flow

```typescript
describe('Candidate Registration E2E', () => {
  
  it('should complete full registration flow', async () => {
    // 1. Register candidate
    const registerRes = await request(app.getHttpServer())
      .post('/api/v1/candidates')
      .attach('cv', 'test-files/valid-cv.pdf')
      .field('name', 'John Doe')
      .field('email', 'john@example.com')
      .field('age', 25)
      .field('country', 'USA')
      .field('city', 'New York')
      .field('english_level', 'B2')
      .field('phone', '+1 555 123 4567')
      .expect(201);

    const candidateId = registerRes.body.data.id;

    // 2. Verify candidate is in list
    const listRes = await request(app.getHttpServer())
      .get('/api/v1/candidates')
      .expect(200);

    const savedCandidate = listRes.body.data.find(c => c.id === candidateId);
    expect(savedCandidate).toBeDefined();
    expect(savedCandidate.status).toBe('In Review');

    // 3. Download CV
    const cvRes = await request(app.getHttpServer())
      .get(`/api/v1/candidates/${candidateId}/cv`)
      .expect(200);

    expect(cvRes.headers['content-type']).toBe('application/pdf');

    // 4. Update candidate status
    const updateRes = await request(app.getHttpServer())
      .patch(`/api/v1/candidates/${candidateId}`)
      .send({ status: 'Accepted' })
      .expect(200);

    expect(updateRes.body.data.status).toBe('Accepted');

    // 5. Verify status change in list
    const finalListRes = await request(app.getHttpServer())
      .get('/api/v1/candidates')
      .expect(200);

    const updatedCandidate = finalListRes.body.data.find(c => c.id === candidateId);
    expect(updatedCandidate.status).toBe('Accepted');
  });
});
```

---

## Test Coverage Goals

- **Unit Tests:** Aim for 80%+ code coverage
- **Integration Tests:** Cover all API endpoints
- **E2E Tests:** Cover main user workflows
- **Frontend:** Aim for 70%+ component coverage

---

## Running Tests

```bash
# All tests
npm run test

# Unit tests only
npm run test -- --testPathPattern=unit

# Integration tests only
npm run test -- --testPathPattern=integration

# E2E tests only
npm run test:e2e

# With coverage
npm run test:cov

# Watch mode
npm run test:watch
```

---

## Test Data & Fixtures

Create `tests/fixtures/` for reusable test data:

```typescript
// tests/fixtures/candidate.fixture.ts
export const validCandidateDto = {
  name: 'John Doe',
  email: 'john@example.com',
  phone: '+591 70000000',
  age: 25,
  country: 'USA',
  city: 'New York',
  english_level: 'B2'
};

export const validCvFile = {
  originalname: 'cv.pdf',
  mimetype: 'application/pdf',
  size: 1024000,
  buffer: Buffer.from([...])
};
```

---

## Continuous Integration Testing

- Run all tests on every commit (Git hooks)
- Run tests on pull requests (GitHub Actions)
- Fail build if coverage < 80%
- Report test results in PR comments
