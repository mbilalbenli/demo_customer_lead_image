using Domain.Lead.Enums;

namespace Application.Lead.Queries.GetLeadById;

public sealed record LeadDetailResponse
{
    public required Guid Id { get; init; }
    public required string Name { get; init; }
    public required string Email { get; init; }
    public required string Phone { get; init; }
    public required LeadStatus Status { get; init; }
    public required int ImageCount { get; init; }
    public required int AvailableImageSlots { get; init; }
    public required bool CanAddMoreImages { get; init; }
    public required DateTime CreatedAt { get; init; }
    public required DateTime UpdatedAt { get; init; }
    public List<ImageSummary>? Images { get; init; }
}

public sealed record ImageSummary
{
    public required Guid Id { get; init; }
    public required string FileName { get; init; }
    public required string ContentType { get; init; }
    public required string Size { get; init; }
    public required DateTime UploadedAt { get; init; }
}