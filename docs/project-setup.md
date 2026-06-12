# Project Setup & Configuration

## Tech Stack

### Backend
- **Runtime:** Node.js 18.x LTS
- **Framework:** NestJS 10.x
- **Database:** PostgreSQL 14.x
- **ORM:** TypeORM 0.3.x
- **File Handling:** Multer (for multipart form-data)
- **Validation:** class-validator, class-transformer
- **Testing:** Jest, Supertest

### Frontend
- **Runtime:** Node.js 18.x LTS
- **Framework:** React 18.x
- **Build Tool:** Vite or Create React App
- **Styling:** CSS/SCSS or Tailwind CSS
- **HTTP Client:** Axios or Fetch API
- **Testing:** Jest, React Testing Library

### Infrastructure
- **Version Control:** Git
- **Container:** Docker & Docker Compose
- **CI/CD:** GitHub Actions or GitLab CI
- **Environment:** Development, Staging, Production

---

## Prerequisites

- **Node.js:** Version 18.x or higher
- **npm or yarn:** Latest stable version
- **PostgreSQL:** Version 14.x
- **Git:** Latest stable version
- **Docker & Docker Compose** (optional, for containerization)

---

## Installation

### 1. Clone Repository
```bash
git clone https://github.com/your-org/sw3-recruitment.git
cd sw3-recruitment
```

### 2. Backend Setup

#### 2.1 Install Dependencies
```bash
cd backend
npm install
```

#### 2.2 Environment Configuration
Create `.env` file in backend directory:

```env
# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=postgres
DATABASE_PASSWORD=your_secure_password
DATABASE_NAME=recruitment_db
DATABASE_SSL=false

# Application
NODE_ENV=development
APP_PORT=3000
APP_HOST=0.0.0.0

# File Storage
CV_FILES_PATH=./cv_files
CV_MAX_SIZE_MB=5

# CORS
CORS_ORIGIN=http://localhost:5173

# Logging
LOG_LEVEL=debug

# JWT (for future auth)
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRATION=7d
```

#### 2.3 Initialize Database
```bash
# Create database
createdb recruitment_db

# Run migrations
npm run typeorm migration:run

# Or if using Flyway
npm run flyway:migrate
```

#### 2.4 Create cv_files Directory
```bash
mkdir -p cv_files
chmod 755 cv_files
```

#### 2.5 Start Backend
```bash
# Development mode (with hot reload)
npm run start:dev

# Production mode
npm run build
npm run start:prod
```

Backend should be running on `http://localhost:3000`.

---

### 3. Frontend Setup

#### 3.1 Install Dependencies
```bash
cd frontend
npm install
```

#### 3.2 Environment Configuration
Create `.env` file in frontend directory:

```env
# API
VITE_API_BASE_URL=http://localhost:3000/api/v1

# App
VITE_APP_NAME=Recruitment WebApp
```

For Create React App, use `.env` with `REACT_APP_` prefix:
```env
REACT_APP_API_BASE_URL=http://localhost:3000/api/v1
```

#### 3.3 Start Frontend
```bash
# Development mode
npm run dev

# Or for Create React App
npm start

# Production build
npm run build
```

Frontend should be running on `http://localhost:5173` (Vite) or `http://localhost:3000` (CRA).

---

## Docker Setup (Optional)

### Docker Compose Configuration

Create `docker-compose.yml` in project root:

```yaml
version: '3.9'

services:
  postgres:
    image: postgres:14
    container_name: recruitment_db
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: recruitment_db
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: recruitment_backend
    environment:
      DATABASE_HOST: postgres
      DATABASE_PORT: 5432
      DATABASE_USER: postgres
      DATABASE_PASSWORD: postgres
      DATABASE_NAME: recruitment_db
      NODE_ENV: development
      APP_PORT: 3000
    ports:
      - "3000:3000"
    depends_on:
      postgres:
        condition: service_healthy
    volumes:
      - ./backend:/app
      - ./cv_files:/app/cv_files

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: recruitment_frontend
    environment:
      VITE_API_BASE_URL: http://localhost:3000/api/v1
    ports:
      - "5173:5173"
    depends_on:
      - backend
    volumes:
      - ./frontend:/app

volumes:
  postgres_data:
```

### Start with Docker Compose
```bash
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

---

## NPM Scripts

### Backend

```json
{
  "scripts": {
    "start": "nest start",
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "start:prod": "node dist/main",
    "build": "nest build",
    "lint": "eslint \"{src,apps,libs,test}/**/*.ts\"",
    "format": "prettier --write \"src/**/*.ts\" \"test/**/*.ts\"",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage",
    "test:debug": "node --inspect-brk -r tsconfig-paths/register -r ts-node/register node_modules/.bin/jest --runInBand",
    "test:e2e": "jest --config ./test/jest-e2e.json",
    "typeorm": "typeorm-cli",
    "migration:create": "typeorm migration:create",
    "migration:generate": "typeorm migration:generate",
    "migration:run": "typeorm migration:run",
    "migration:revert": "typeorm migration:revert"
  }
}
```

### Frontend

```json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint src/**/*.{ts,tsx}",
    "format": "prettier --write \"src/**/*.{ts,tsx,css}\"",
    "test": "vitest",
    "test:ui": "vitest --ui",
    "test:coverage": "vitest --coverage"
  }
}
```

---

## Environment-Specific Configuration

### Development
- Database: Local PostgreSQL
- File Storage: Local filesystem (`./cv_files`)
- CORS: Open to localhost
- Logging: Verbose
- API: `http://localhost:3000`

### Staging
- Database: Staging PostgreSQL server
- File Storage: S3 or cloud storage
- CORS: Restricted to staging domain
- Logging: Info level
- API: `https://staging-api.recruitment.local`

### Production
- Database: Production PostgreSQL (encrypted, backed up)
- File Storage: S3 or cloud storage with CDN
- CORS: Restricted to production domain only
- Logging: Error + Warning only
- API: `https://api.recruitment.com`
- HTTPS: Enabled with SSL/TLS certificate

---

## Database Migrations

### TypeORM Migrations

Create a new migration:
```bash
npm run migration:generate -- -n CreateCandidatesTable
```

Run migrations:
```bash
npm run migration:run
```

Revert last migration:
```bash
npm run migration:revert
```

---

## Testing

### Backend Unit Tests
```bash
npm run test
npm run test:watch
npm run test:cov
```

### Backend E2E Tests
```bash
npm run test:e2e
```

### Frontend Unit Tests
```bash
npm run test
npm run test:watch
```

### Run All Tests
```bash
npm run test:all
```

---

## Build & Deployment

### Backend Build
```bash
npm run build
```

Outputs to `dist/` directory.

### Frontend Build
```bash
npm run build
```

Outputs to `dist/` directory (Vite) or `build/` (CRA).

### Deploy to Production

1. **Build Artifacts:**
   ```bash
   cd backend && npm run build
   cd frontend && npm run build
   ```

2. **Deploy Backend:**
   ```bash
   # Copy dist/ to server
   # Copy cv_files/ to server
   # Run migrations
   # Start service
   ```

3. **Deploy Frontend:**
   ```bash
   # Upload dist/ to CDN or web server
   # Update DNS/load balancer
   ```

4. **Environment Variables:**
   - Set production `.env` on server (securely, not in version control).
   - Use secrets management (GitHub Secrets, AWS Secrets Manager, etc.).

---

## Port Configuration

- **Backend API:** `3000` (default)
- **Frontend (Vite):** `5173` (default)
- **Frontend (CRA):** `3000` (default, conflicts with backend if both run locally)
- **PostgreSQL:** `5432` (default)
- **pgAdmin (optional):** `5050`

---

## Troubleshooting

### Database Connection Error
```
Error: connect ECONNREFUSED 127.0.0.1:5432
```
- Check PostgreSQL is running: `pg_isready`
- Verify DATABASE_HOST and DATABASE_PORT in `.env`
- Ensure database exists: `\l` in psql

### File Upload Error
```
Error: ENOENT: no such file or directory, open './cv_files/...'
```
- Create directory: `mkdir -p cv_files`
- Check permissions: `chmod 755 cv_files`
- Verify CV_FILES_PATH in `.env`

### CORS Error in Frontend
```
Access to XMLHttpRequest blocked by CORS policy
```
- Check backend `.env` has correct CORS_ORIGIN
- Verify frontend is accessing correct API URL
- Check backend is running and accessible

### Port Already in Use
```
Error: listen EADDRINUSE :::3000
```
- Kill process: `lsof -ti :3000 | xargs kill -9`
- Or change APP_PORT in `.env`

---

## Development Workflow

1. **Create feature branch:**
   ```bash
   git checkout -b feature/SW3-XXX-description
   ```

2. **Write tests first**
   ```bash
   npm run test:watch
   ```

3. **Implement feature:**
   - Update docs if needed
   - Write code
   - Ensure tests pass

4. **Format & lint:**
   ```bash
   npm run format
   npm run lint
   ```

5. **Commit & push:**
   ```bash
   git add .
   git commit -m "feat: SW3-XXX description"
   git push origin feature/SW3-XXX-description
   ```

6. **Create pull request**
   - Reference issue number
   - Link to documentation

---

## Version Management

- **Semantic Versioning:** MAJOR.MINOR.PATCH (e.g., 1.2.3)
- **Changelog:** Maintain `CHANGELOG.md`
- **Releases:** Tag in Git: `git tag -a v1.0.0 -m "Release v1.0.0"`

---

## Continuous Integration

### GitHub Actions Workflow (`.github/workflows/test.yml`)

```yaml
name: Tests
on: [push, pull_request]
jobs:
  backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: '18'
      - run: cd backend && npm install && npm run test
  frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: '18'
      - run: cd frontend && npm install && npm run test
```

---

## Monitoring & Logging

### Backend Logging
- Use NestJS Logger or Winston
- Log to file: `logs/app.log`
- Log to console in development
- Structured logging (JSON format) in production

### Frontend Error Tracking
- Sentry or similar for error reporting
- Log to browser console in development
- Send errors to backend for aggregation

---

## Security Checklist

- [ ] `.env` files are in `.gitignore`
- [ ] No hardcoded secrets in code
- [ ] CORS is restrictive in production
- [ ] Input validation on all endpoints
- [ ] SQL injection prevention (ORM usage)
- [ ] File upload size limits enforced
- [ ] HTTPS enabled in production
- [ ] Database backups automated
- [ ] Rate limiting on API (future)
- [ ] Authentication/authorization (future)
