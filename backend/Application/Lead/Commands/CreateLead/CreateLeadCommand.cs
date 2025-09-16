using Domain.Lead.Enums;
using MediatR;

namespace Application.Lead.Commands.CreateLead;

public sealed record CreateLeadCommand : IRequest<CreateLeadResponse>
{
    public required string Name { get; init; }
    public required string Email { get; init; }
    public required string Phone { get; init; }
    public LeadStatus Status { get; init; } = LeadStatus.New;
    public string? Description { get; init; }
}