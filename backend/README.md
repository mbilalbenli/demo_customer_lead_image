# Backend API - Clean Architecture with DDD, CQRS, Marten & PostgreSQL

## Architecture
- **DDD** - Domain Driven Design
- **Clean Architecture** - Separation of concerns
- **CQRS** - Command Query Responsibility Segregation with MediatR
- **Mapster** - Object mapping
- **Carter** - Minimal API endpoints
- **Marten** - Document database on PostgreSQL
- **PostgreSQL** - Database

## Prerequisites
- .NET 9.0 SDK
- Docker & Docker Compose
- PostgreSQL (via Docker)

## Quick Start

1. **Start PostgreSQL:**
```bash
docker-compose up -d
```

2. **Run the backend:**
```bash
cd backend
dotnet restore
dotnet run
```

3. **Test endpoints:**
```bash
# Health check endpoints
curl http://localhost:5000/api/health
curl http://localhost:5000/api/health/live
curl http://localhost:5000/api/health/ready
```

4. **Swagger UI:**
Open browser: http://localhost:5000/swagger

## Health Checks
- `/api/health` - Full system health with all services
- `/api/health/live` - Liveness probe
- `/api/health/ready` - Readiness probe
- `/health` - ASP.NET Core health endpoint

## Database
PostgreSQL runs in Docker:
- Host: localhost
- Port: 5432
- Database: demo_db
- User: postgres
- Password: postgres

## Project Structure
```
backend/
├── Domain/           # Entities, Value Objects
├── Application/      # CQRS Queries/Commands, Handlers
├── Infrastructure/   # Database, External Services
├── API/             # Carter Modules, Endpoints
└── Program.cs       # Application setup
```