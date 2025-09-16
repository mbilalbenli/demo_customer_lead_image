namespace Infrastructure.Persistence.Entities;

// Document representation for Base64 image storage in Marten
public class LeadImageDocument
{
    public Guid Id { get; set; }
    public Guid LeadId { get; set; }

    // CRITICAL: Store image as Base64 string directly
    public string Base64Data { get; set; } = string.Empty;

    // Metadata
    public string FileName { get; set; } = string.Empty;
    public string ContentType { get; set; } = string.Empty;
    public int SizeInBytes { get; set; }
    public string? Description { get; set; }

    // Timestamps
    public DateTime CreatedAt { get; set; }
    public DateTime UploadedAt { get; set; }
    public DateTime? ModifiedAt { get; set; }
}