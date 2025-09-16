namespace Application.Image.Commands.ReplaceImage;

public sealed record ReplaceImageResponse
{
    public required Guid OldImageId { get; init; }
    public required Guid NewImageId { get; init; }
    public required Guid LeadId { get; init; }
    public required string FileName { get; init; }
    public required string Size { get; init; }
    public required string Message { get; init; }
}