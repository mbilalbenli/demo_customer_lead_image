namespace Application.Image.Commands.ValidateImage;

public sealed record ValidateImageResponse
{
    public required bool IsValid { get; init; }
    public required string FileName { get; init; }
    public required string DetectedContentType { get; init; }
    public required int SizeBytes { get; init; }
    public bool ExceedsLimit { get; init; }
    public int MaxAllowedBytes { get; init; }
    public bool SuggestCompression { get; init; }
    public string? ErrorCode { get; init; }
    public string? ErrorMessage { get; init; }
}

