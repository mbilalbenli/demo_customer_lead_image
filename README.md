## API Endpoints

Base URL

- Local (Docker): http://localhost:5000

### Health

- GET /api/health — Returns overall system health summary (200)
- GET /api/health/live — Liveness probe (200)
- GET /api/health/ready — Readiness probe (200 when ready, 503 otherwise)

### Leads

- GET /api/leads — List leads (200)
  - Query: none
- GET /api/leads/{id:guid} — Get lead by id (200, 404)
  - Route: id (Guid)
- GET /api/leads/search — Search leads (200)
  - Query: searchTerm? (string), searchByName? (bool), searchByEmail? (bool), searchByPhone? (bool), minImageCount? (int), maxImageCount? (int), onlyLeadsWithImages? (bool), onlyLeadsAtImageLimit? (bool), pageNumber? (int), pageSize? (int)
- POST /api/leads — Create a lead (201)
  - Body: { name: string, email: string, phone: string, status?: LeadStatus, description?: string }
- PUT /api/leads/{id:guid} — Update a lead (200, 404)
  - Route: id (Guid)
  - Body: { name?: string, email?: string, phone?: string, status?: LeadStatus }
- DELETE /api/leads/{id:guid} — Delete a lead (204, 404)
  - Route: id (Guid)

### Lead Images

- GET /api/leads/{leadId:guid}/images — List images for a lead (200)
  - Route: leadId (Guid)
  - Query: includeBase64Data? (bool, default true), pageNumber? (int, default 1), pageSize? (int, default 5)
- GET /api/leads/{leadId:guid}/images/count — Get image count (200)
  - Route: leadId (Guid)
- POST /api/leads/{leadId:guid}/images — Upload image for a lead (201, 400)
  - Route: leadId (Guid)
  - Body: { base64Image: string, fileName: string, contentType?: string, description?: string }
- PUT /api/leads/{leadId:guid}/images/{imageId:guid} — Replace an image (200, 400, 404)
  - Route: leadId (Guid), imageId (Guid)
  - Body: { newBase64Image: string, newFileName: string, newContentType?: string, newDescription?: string }
- DELETE /api/leads/{leadId:guid}/images/{imageId:guid} — Delete an image (200, 404)
  - Route: leadId (Guid), imageId (Guid)

Notes

- Response shapes are defined by the Application layer DTOs (e.g., LeadListResponse, LeadDetailResponse, UploadImageResponse).
- Health endpoints are unauthenticated and intended for probes; others follow standard JSON request/response bodies.
 


 