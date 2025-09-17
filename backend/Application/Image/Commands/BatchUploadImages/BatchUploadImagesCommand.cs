using MediatR;

namespace Application.Image.Commands.BatchUploadImages;

public sealed record BatchUploadItem
{
    public required string Base64Image { get; init; }
    public required string FileName { get; init; }
    public string? ContentType { get; init; }
    public string? Description { get; init; }
}

public sealed record BatchUploadImagesCommand : IRequest<BatchUploadImagesResponse>
{
    public required Guid LeadId { get; init; }
    public required IReadOnlyList<BatchUploadItem> Items { get; init; }
}

