using Domain.Lead.Enums;

namespace Application.Lead.Queries.GetLeadsList;

public sealed record LeadListResponse
{
    public required List<LeadListItem> Items { get; init; }
    public required int TotalCount { get; init; }
    public required int PageNumber { get; init; }
    public required int PageSize { get; init; }
    public required int TotalPages { get; init; }
    public required bool HasPreviousPage { get; init; }
    public required bool HasNextPage { get; init; }
}

public sealed record LeadListItem
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
}