using Domain.Lead.Enums;

namespace Application.Lead.Commands.UpdateLead;

public sealed record UpdateLeadResponse
{
    public required Guid Id { get; init; }
    public required string Name { get; init; }
    public required string Email { get; init; }
    public required string Phone { get; init; }
    public required LeadStatus Status { get; init; }
    public required int ImageCount { get; init; }
    public required int AvailableImageSlots { get; init; }
    public required DateTime UpdatedAt { get; init; }
}