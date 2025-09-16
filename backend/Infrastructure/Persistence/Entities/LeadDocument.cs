using Domain.Lead.Enums;

namespace Infrastructure.Persistence.Entities;

// Document representation for Marten storage
public class LeadDocument
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public LeadStatus Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }

    // Denormalized count for quick queries
    public int ImageCount { get; set; }
}