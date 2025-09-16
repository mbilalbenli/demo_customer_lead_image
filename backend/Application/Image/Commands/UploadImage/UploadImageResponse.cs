namespace Application.Image.Commands.UploadImage;

public sealed record UploadImageResponse
{
    public required Guid ImageId { get; init; }
    public required Guid LeadId { get; init; }
    public required string FileName { get; init; }
    public required string ContentType { get; init; }
    public required string Size { get; init; }
    public required int CurrentImageCount { get; init; }
    public required int RemainingSlots { get; init; }
    public required bool IsAtLimit { get; init; }
    public required DateTime UploadedAt { get; init; }
    public string? SuggestionMessage { get; init; }
}