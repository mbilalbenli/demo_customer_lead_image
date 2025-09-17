namespace Application.Image.Commands.BatchUploadImages;

public sealed record BatchUploadItemResult
{
    public Guid? ImageId { get; init; }
    public required string FileName { get; init; }
    public bool Success { get; init; }
    public string? ErrorCode { get; init; }
    public string? ErrorMessage { get; init; }
}

public sealed record BatchUploadImagesResponse
{
    public required string LeadId { get; init; }
    public required int UploadedCount { get; init; }
    public required int FailedCount { get; init; }
    public required int CurrentImageCount { get; init; }
    public required int RemainingSlots { get; init; }
    public required IReadOnlyList<BatchUploadItemResult> Results { get; init; }
}

