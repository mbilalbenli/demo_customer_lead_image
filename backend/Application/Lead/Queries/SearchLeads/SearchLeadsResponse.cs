using Domain.Lead.Enums;

namespace Application.Lead.Queries.SearchLeads;

public sealed record SearchLeadsResponse
{
    public required List<SearchLeadItem> Results { get; init; }
    public required int TotalResults { get; init; }
    public required string? SearchTerm { get; init; }
    public required int PageNumber { get; init; }
    public required int PageSize { get; init; }
    public required int TotalPages { get; init; }
}

public sealed record SearchLeadItem
{
    public required Guid Id { get; init; }
    public required string Name { get; init; }
    public required string Email { get; init; }
    public required string Phone { get; init; }
    public required LeadStatus Status { get; init; }
    public required int ImageCount { get; init; }
    public required int AvailableImageSlots { get; init; }
    public required bool IsAtImageLimit { get; init; }
    public required DateTime CreatedAt { get; init; }
    public required double? RelevanceScore { get; init; }
}