using MediatR;

namespace Application.Lead.Queries.SearchLeads;

public sealed record SearchLeadsQuery : IRequest<SearchLeadsResponse>
{
    public string? SearchTerm { get; init; }
    public bool SearchByName { get; init; } = true;
    public bool SearchByEmail { get; init; } = true;
    public bool SearchByPhone { get; init; } = true;
    public int? MinImageCount { get; init; }
    public int? MaxImageCount { get; init; }
    public bool OnlyLeadsWithImages { get; init; } = false;
    public bool OnlyLeadsAtImageLimit { get; init; } = false;
    public int PageNumber { get; init; } = 1;
    public int PageSize { get; init; } = 10;
}