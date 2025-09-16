using Domain.Lead.Enums;
using MediatR;

namespace Application.Lead.Queries.GetLeadsList;

public sealed record GetLeadsListQuery : IRequest<LeadListResponse>
{
    public int PageNumber { get; init; } = 1;
    public int PageSize { get; init; } = 10;
    public LeadStatus? StatusFilter { get; init; }
    public string? SortBy { get; init; } = "CreatedAt";
    public bool SortDescending { get; init; } = true;
    public bool IncludeImageCounts { get; init; } = true;
}