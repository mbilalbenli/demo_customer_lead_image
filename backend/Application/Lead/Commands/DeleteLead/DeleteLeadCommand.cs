using MediatR;

namespace Application.Lead.Commands.DeleteLead;

public sealed record DeleteLeadCommand : IRequest<Unit>
{
    public required Guid Id { get; init; }
}