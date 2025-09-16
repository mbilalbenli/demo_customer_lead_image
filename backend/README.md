# Lead Image Management API

A robust .NET 9 API for managing customer/lead images with strict enforcement of a 10-image maximum per lead. Images are stored as Base64-encoded strings directly in PostgreSQL using Marten.

## 🎯 Key Features

- **✅ 10-Image Limit Strictly Enforced** - Multiple validation layers ensure no lead exceeds 10 images
- **✅ Base64 Storage** - Images stored as Base64 strings in the database (no external storage)
- **✅ Clever 11th Image Handling** - User-friendly messages with replacement suggestions
- **✅ Clean Architecture** - DDD, CQRS, Clean Architecture patterns
- **✅ Image Compression** - Automatic compression for images > 1MB

## 🏗️ Architecture

- **Domain-Driven Design (DDD)** - Rich domain models with business logic
- **Clean Architecture** - Clear separation of concerns
- **CQRS Pattern** - Using MediatR for command/query separation
- **Repository Pattern** - For data access abstraction
- **Carter** - Minimal API endpoints
- **Marten** - Document storage in PostgreSQL
- **FluentValidation** - Request validation
- **Mapster** - Object mapping

## 📋 Requirements

- .NET 9.0 SDK
- PostgreSQL 14+
- Docker (optional, for PostgreSQL)

## 🚀 Getting Started

### 1. Start PostgreSQL

Using Docker:
```bash
cd backend
docker-compose up -d
```

Or update connection string in `API/appsettings.json` for existing PostgreSQL.

### 2. Run the API

```bash
cd backend/API
dotnet restore
dotnet run
```

API starts on `http://localhost:5000`

### 3. Access Swagger

Navigate to: `http://localhost:5000/swagger`

## 📚 API Endpoints

### Lead Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/leads` | Create a new lead |
| GET | `/api/leads/{id}` | Get lead by ID with image count |
| GET | `/api/leads` | Get paginated list of leads |
| PUT | `/api/leads/{id}` | Update lead information |
| DELETE | `/api/leads/{id}` | Delete lead and all images |

### Image Management (10-Image Limit Enforced)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/leads/{leadId}/images` | Upload Base64 image (max 10) |
| GET | `/api/leads/{leadId}/images` | Get images with Base64 data |
| GET | `/api/leads/{leadId}/images/status` | Get count and availability |
| DELETE | `/api/leads/{leadId}/images/{imageId}` | Delete an image |
| PUT | `/api/leads/{leadId}/images/{imageId}/replace` | Replace image at limit |

## 📸 Image Upload Example

### Request
```json
POST /api/leads/{leadId}/images
{
  "base64Image": "data:image/jpeg;base64,/9j/4AAQSkZJRg...",
  "fileName": "photo.jpg",
  "contentType": "image/jpeg",
  "description": "Profile photo"
}
```

### Success Response
```json
{
  "imageId": "123e4567-...",
  "currentImageCount": 7,
  "remainingSlots": 3,
  "isAtLimit": false,
  "suggestionMessage": "You can add 3 more images."
}
```

### Limit Reached (409)
```json
{
  "error": "Image limit reached",
  "message": "You've reached the maximum of 10 images...",
  "currentCount": 10,
  "suggestion": "Delete an image or use replace endpoint"
}
```

## 🔒 10-Image Limit Enforcement

Multi-layer validation:
1. **Domain**: `Lead.CanAddImage()` method
2. **Validator**: FluentValidation checks count
3. **Handler**: Double-checks before save
4. **API**: Returns 409 with helpful message

## 🎯 Technical Specs

- **Max Images**: 10 per lead
- **Max Size**: 5MB per image
- **Formats**: JPEG, PNG, GIF, WebP
- **Storage**: PostgreSQL via Marten
- **Compression**: Auto for images > 1MB

## Project Structure
```
backend/
├── Domain/           # Entities, Value Objects, Rules
├── Application/      # Commands, Queries, Handlers
├── Infrastructure/   # Database, Image Processing
├── API/             # Carter Modules, Program.cs
└── Tests/           # Unit and Integration Tests
```