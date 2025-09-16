namespace Application.Image.Queries.GetImageCount;

public sealed record ImageCountResponse
{
    public required Guid LeadId { get; init; }
    public required int CurrentCount { get; init; }
    public required int MaxCount { get; init; }
    public required int AvailableSlots { get; init; }
    public required bool CanAddMore { get; init; }
    public required string StatusMessage { get; init; }
}