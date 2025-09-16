namespace Application.Image.Commands.DeleteImage;

public sealed record DeleteImageResponse
{
    public required bool Success { get; init; }
    public required int RemainingImageCount { get; init; }
    public required int AvailableSlots { get; init; }
    public required string Message { get; init; }
}