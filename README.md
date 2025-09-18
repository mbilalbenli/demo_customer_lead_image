## API Endpoints

Base URL

- Local (Docker/host): `http://localhost:5000`
- Android emulator from app: `http://10.0.2.2:5000`

### Health

- GET `/health` — Health check (200)

### Leads

- GET `/api/leads` — List leads (200)
  - Query: `skip?` (int), `take?` (int), `sortBy?` (string), `sortDescending?` (bool), `status?` (LeadStatus)
- GET `/api/leads/{id:guid}` — Get lead by id (200, 404)
- GET `/api/leads/search` — Search leads (200)
  - Query: `searchTerm?` (string)
- POST `/api/leads` — Create a lead (201)
  - Body: `{ Name: string, Email: string, Phone: string, Status?: LeadStatus, Description?: string }`
- PUT `/api/leads/{id:guid}` — Update a lead (200, 404)
  - Body: `{ Name?: string, Email?: string, Phone?: string, Status?: LeadStatus, Description?: string }`
- DELETE `/api/leads/{id:guid}` — Delete a lead (204, 404)

### Lead Images

- GET `/api/leads/{leadId:guid}/images` — List images for a lead (200)
  - Query: pagination supported via page/size in application layer (API exposes `skip`/`take`)
- GET `/api/leads/{leadId:guid}/images/count` — Get image count (200)
- POST `/api/leads/{leadId:guid}/images` — Upload Base64 image (201, 400)
  - Body: `{ base64Image: string, fileName: string, contentType?: string, description?: string }`
- DELETE `/api/leads/{leadId:guid}/images/{imageId:guid}` — Delete an image (200, 404)

Notes

- Response shapes are defined by the Application layer DTOs (e.g., `LeadListResponse`, `LeadDetailResponse`, `UploadImageResponse`).
- Health endpoint is unauthenticated and intended for probes.

## Mobile Packages

| Package | Why we use it |
| --- | --- |
| `flutter_riverpod` | Scalable state management and dependency scoping for pages, view models, and providers. |
| `get_it` | Simple service locator for wiring use cases, repositories, and services. |
| `dio` | Robust HTTP client with interceptors, timeouts, and typed responses. |
| `go_router` | Declarative routing and nested routes (lead detail and image viewer). |
| `freezed_annotation`/`freezed` | Immutable data classes, copyWith, and pattern matching for states and entities. |
| `json_annotation`/`json_serializable`/`build_runner` | Code generation for JSON (de)serialization of DTOs and entities. |
| `shared_preferences` | Lightweight local cache for leads/images metadata when offline. |
| `dartz` | Functional primitives (`Either`) to model success/error from repositories. |
| `connectivity_plus` | Detect online/offline to decide between remote and cached data. |
| `uuid` | Generate stable temporary IDs for client-side items. |
| `image` | Client-side image utilities (size, processing) prior to upload. |
| `image_picker` | Pick images from camera/gallery for uploads. |
| `permission_handler` | Runtime permissions for camera/storage access. |
| `photo_view` | Zoomable image viewer experience. |
| `path_provider` | Resolve platform file paths for caching/temporary files. |
| `camera` | Capture photos directly inside the app (when enabled). |
| `logger` | Structured logging for diagnostics in app and network layer. |
| `flutter_dotenv` | Load environment variables (e.g., API base URL) at runtime. |
| `intl` | Formatting/localization helpers alongside generated l10n. | 

## Backend Packages

| Package | Why we use it |
| --- | --- |
| `Carter` | Minimal, modular endpoint mapping for ASP.NET Core (clean route modules). |
| `MediatR` | Implements CQRS (commands/queries) with request/handler patterns. |
| `Mapster`/`Mapster.DependencyInjection` | Fast object mapping between domain/entities and DTOs. |
| `Marten`/`Marten.AspNetCore` | Postgres-backed document/data access and unit-of-work. |
| `Npgsql` | PostgreSQL ADO.NET driver used by Marten and direct DB access. |
| `FluentValidation` | Strongly-typed validation for commands and inputs. |
| `FluentValidation.DependencyInjectionExtensions` | Register validators into DI container. |
| `Microsoft.Extensions.Diagnostics.HealthChecks` | Expose health status and integrate with probes. |
| `AspNetCore.HealthChecks.NpgSql` | Postgres-specific health check for DB connectivity. |
| `Swashbuckle.AspNetCore` | Swagger/OpenAPI generation and UI for API exploration. |
| `SixLabors.ImageSharp` | Server-side image processing/validation routines. |

## Tech Stack

- Mobile (Flutter/Dart)
  - Flutter + Dart for cross‑platform UI
  - Riverpod for state management
  - GoRouter for navigation and deep‑linking
  - Dio for HTTP with interceptors
  - GetIt for dependency injection
  - Freezed + JSON Serializable for immutable models and codegen
  - Shared Preferences for lightweight caching
  - Connectivity, UUID, Image/ImagePicker/Camera, Permission Handler, PhotoView for imaging and UX

- Backend (.NET / ASP.NET Core)
  - ASP.NET Core Minimal APIs
  - Carter for modular route mapping
  - MediatR for CQRS (commands/queries)
  - Mapster for fast DTO mapping
  - Marten + PostgreSQL (via Npgsql) for data storage and UoW
  - FluentValidation for input validation
  - Health Checks and Swagger/OpenAPI for operability and docs
  - ImageSharp for server‑side image validation/processing

- Tooling & Ops
  - Docker / docker-compose for local orchestration
  - Build Runner for code generation (mobile)
  - Lints + test frameworks for quality (mobile and backend)
<!-- Demo Video -->

<div align="center">

<video src="Android%20Emulator%20-%205556-Medium_Phone_API_36_5554%202025-09-18%2004-16-18.mp4" controls playsinline muted style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);"></video>

<br/>

<a href="Android%20Emulator%20-%205556-Medium_Phone_API_36_5554%202025-09-18%2004-16-18.mp4">▶️ Watch the demo (MP4)</a>

</div>
