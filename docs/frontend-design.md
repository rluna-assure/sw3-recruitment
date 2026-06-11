# Frontend Design - React Implementation

## Pages & Routes

### Registration Page (`frontend/src/pages/RegistrationPage.tsx`)
- **Route:** `/register` or `/`
- **Purpose:** Public form for candidates to submit their details and CV.
- **Components:**
  - `RegistrationForm`
  - `FileUploadInput`
  - `SuccessModal` or success message
- **State Management:** React hooks (`useState`, `useContext` for API service).
- **Behavior:**
  - User fills form fields: name, email, phone, age, country, city, English level.
  - User selects PDF file for upload.
  - On submit: validate locally (optional), then send `POST /api/v1/candidates` with multipart form-data.
  - On success: show confirmation message with candidate ID, redirect to homepage or show success page.
  - On error: display error message (CV required, file size, invalid format, duplicate email, etc.).

### Admin Panel (`frontend/src/pages/AdminPanel.tsx`)
- **Route:** `/admin` (no auth in MVP)
- **Purpose:** Recruiters view and manage candidate applications.
- **Components:**
  - `CandidateTable`
  - `FilterBar`
  - `StatusUpdateModal`
- **State Management:** React hooks and API service for `GET /candidates` and `PATCH /candidates/{id}`.
- **Features:**
  - Display table of candidates with columns: Name, Email, Country, English Level, Status, Created Date, Actions.
  - Filter by country (dropdown or text input).
  - Filter by English level (dropdown: A1–C2).
  - Filter by status (dropdown: In Review, Accepted, Rejected).
  - Sort by created date (most recent first, default).
  - Action buttons: "View CV" (link to `/api/v1/candidates/{id}/cv`), "Accept", "Reject", "In Review".
  - Status update inline or modal confirmation.
  - Real-time table refresh after status update.
  - Traffic-light color coding: green (C1/C2), yellow (B1/B2), red (A1/A2).

### CV Viewer / Download (`frontend/src/pages/CVViewer.tsx` or inline)
- **Route:** `/candidates/{id}/cv` or direct link to API endpoint.
- **Purpose:** View or download candidate CV.
- **Implementation:** Can be API redirect or embedded viewer (e.g., using `react-pdf`).

---

## Components

### RegistrationForm (`frontend/src/components/RegistrationForm.tsx`)
- **Props:** 
  - `onSuccess`: callback after successful submission.
  - `onError`: callback if submission fails.
- **State:**
  - Form data: name, email, phone, age, country, city, english_level.
  - File upload state (selected file, uploading flag).
  - Validation errors (local).
- **Fields:**
  - Text inputs: name, email, phone.
  - Number input: age (>= 18 validation).
  - Dropdown: country (predefined list or API).
  - Text input: city.
  - Dropdown: english_level (A1–C2).
  - File input: CV (accept PDF, show size, update on selection).
- **Validation:**
  - Client-side: required fields, email format, age >= 18, file type/size.
  - Server-side: full validation per `docs/validation.md`.
- **Submit:**
  - Serialize as `FormData` (multipart/form-data).
  - POST to `/api/v1/candidates`.
  - Show loading state during request.
  - Handle errors with user-friendly messages.

### FileUploadInput (`frontend/src/components/FileUploadInput.tsx`)
- **Props:**
  - `onChange`: callback with selected file.
  - `accept`: file type filter (default: `.pdf`).
  - `maxSize`: max file size in bytes (default: 5 * 1024 * 1024).
- **Display:**
  - Drag-and-drop area or file input button.
  - Show selected filename and size.
  - Show validation status (✓ or error message).
  - Show warning if file > 5MB.

### CandidateTable (`frontend/src/components/CandidateTable.tsx`)
- **Props:**
  - `candidates`: array of candidate objects.
  - `onStatusUpdate`: callback for status change.
  - `filters`: current filter state.
- **Display:**
  - Columns: ID, Name, Email, Phone, Country, City, English Level, Status, Created At, Actions.
  - Traffic-light color on English Level (visual indicator).
  - Rows sorted by created date (most recent first).
  - Status badge with color (green=Accepted, yellow=In Review, red=Rejected).
  - Action buttons: View CV, Update Status.

### FilterBar (`frontend/src/components/FilterBar.tsx`)
- **Props:**
  - `onFilterChange`: callback with filter values.
- **Dropdowns:**
  - Country: list of countries or text search.
  - English Level: A1, A2, B1, B2, C1, C2.
  - Status: In Review, Accepted, Rejected.
- **Buttons:**
  - "Apply Filters" or auto-apply on change.
  - "Clear Filters" to reset.

### StatusUpdateModal (`frontend/src/components/StatusUpdateModal.tsx`)
- **Props:**
  - `candidate`: candidate object.
  - `visible`: boolean to show/hide modal.
  - `onConfirm`: callback with new status.
  - `onCancel`: callback to close modal.
- **Display:**
  - Show candidate name.
  - Radio buttons for status: Accepted, Rejected, In Review.
  - Confirm and Cancel buttons.

### TrafficLightBadge (`frontend/src/components/TrafficLightBadge.tsx`)
- **Props:**
  - `englishLevel`: enum value (A1–C2).
- **Display:**
  - Green for C1, C2.
  - Yellow for B1, B2.
  - Red for A1, A2.
  - Text showing level.

### SuccessMessage (`frontend/src/components/SuccessMessage.tsx`)
- **Props:**
  - `candidateId`: UUID of newly registered candidate.
  - `onDismiss`: callback to close message.
- **Display:**
  - Confirmation text: "Your application has been submitted successfully!"
  - Show candidate ID.
  - Option to download or view receipt.

---

## Services

### CandidateService (`frontend/src/services/candidateService.ts`)
- **Base URL:** `http://localhost:3000/api/v1` (or from env).
- **Methods:**
  - `registerCandidate(formData: FormData): Promise<Candidate>` — POST /candidates with multipart form-data.
  - `listCandidates(filters?: CandidateFilters): Promise<Candidate[]>` — GET /candidates with query params.
  - `updateCandidateStatus(id: UUID, status: string): Promise<Candidate>` — PATCH /candidates/{id}.
  - `downloadCV(id: UUID): void` — redirect to `/candidates/{id}/cv`.
- **Error Handling:** Parse error responses and throw with message.

---

## Shared / Utility Components

### TrafficLightCalculator (`frontend/src/utils/trafficLightCalculator.ts`)
- Function to map English level to color (green, yellow, red).
- Used in multiple components.

### FormValidator (`frontend/src/utils/formValidator.ts`)
- Local validation for form fields before submission.
- Checks: required, email format, age >= 18, file type/size.

### Constants (`frontend/src/constants/index.ts`)
- Country list.
- English level enum.
- Status enum.
- File size limit (5MB).
- API endpoints.
- Error messages.

---

## Layout & Navigation

### MainLayout (`frontend/src/layout/MainLayout.tsx`)
- Header with logo and navigation.
- Navigation links:
  - "Register" → `/register`
  - "Admin Panel" → `/admin` (no auth in MVP)
  - "Home" → `/`
- Footer with project info.

### Routing (`frontend/src/App.tsx`)
- Routes:
  - `/` → Homepage or RegistrationPage
  - `/register` → RegistrationPage
  - `/admin` → AdminPanel
  - `*` → 404 Not Found page

---

## State Management

- **React Context** for global state (API service, user theme, etc.).
- **Local component state** (useState) for form data and UI state.
- Optional: Redux or Zustand if app grows complex.

---

## API Integration

- **HTTP Client:** Fetch API or Axios.
- **Base URL:** Configured in `.env`.
- **Requests:**
  - `Content-Type: application/json` for JSON payloads.
  - `Content-Type: multipart/form-data` for file uploads (set by browser automatically when using FormData).
- **Response Handling:**
  - Success (200, 201): extract and return data.
  - Client Error (400, 409, 413, 415): extract error message and re-throw or display.
  - Server Error (500): generic error message.

---

## User Experience

- **Loading states:** Show spinner during API calls.
- **Error messages:** Display field-level errors from server (e.g., "CV file size must not exceed 5MB.").
- **Success feedback:** Show confirmation message or toast notification.
- **Responsive design:** Mobile-first approach per `docs/context.md`.
- **Accessibility:** ARIA labels, keyboard navigation, semantic HTML.

---

## Development File Structure

```
frontend/src/
  pages/
    RegistrationPage.tsx
    AdminPanel.tsx
    CVViewer.tsx
    HomePage.tsx
  components/
    RegistrationForm.tsx
    FileUploadInput.tsx
    CandidateTable.tsx
    FilterBar.tsx
    StatusUpdateModal.tsx
    TrafficLightBadge.tsx
    SuccessMessage.tsx
  services/
    candidateService.ts
  utils/
    trafficLightCalculator.ts
    formValidator.ts
  constants/
    index.ts
  layout/
    MainLayout.tsx
  App.tsx
  App.css
  index.tsx
```
