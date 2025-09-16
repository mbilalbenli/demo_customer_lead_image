using MediatR;

namespace Application.Lead.Queries.GetLeadById;

public sealed record GetLeadByIdQuery : IRequest<LeadDetailResponse>
{
    public required Guid Id { get; init; }
    public bool IncludeImages { get; init; } = false;
}