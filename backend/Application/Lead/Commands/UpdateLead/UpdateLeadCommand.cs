using Domain.Lead.Enums;
using MediatR;

namespace Application.Lead.Commands.UpdateLead;

public sealed record UpdateLeadCommand : IRequest<UpdateLeadResponse>
{
    public required Guid Id { get; init; }
    public string? Name { get; init; }
    public string? Email { get; init; }
    public string? Phone { get; init; }
    public LeadStatus? Status { get; init; }
}