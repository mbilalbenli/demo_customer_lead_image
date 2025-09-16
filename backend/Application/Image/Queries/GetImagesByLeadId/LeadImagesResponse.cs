namespace Application.Image.Queries.GetImagesByLeadId;

public sealed record LeadImagesResponse
{
    public required Guid LeadId { get; init; }
    public required List<ImageData> Images { get; init; }
    public required int TotalImageCount { get; init; }
    public required int AvailableSlots { get; init; }
    public required bool IsAtLimit { get; init; }
    public required int PageNumber { get; init; }
    public required int PageSize { get; init; }
    public required int TotalPages { get; init; }
}

public sealed record ImageData
{
    public required Guid Id { get; init; }
    public required string FileName { get; init; }
    public required string ContentType { get; init; }
    public required string Size { get; init; }
    public string? Base64Data { get; init; }
    public string? DataUri { get; init; }
    public required DateTime UploadedAt { get; init; }
    public string? Description { get; init; }
}