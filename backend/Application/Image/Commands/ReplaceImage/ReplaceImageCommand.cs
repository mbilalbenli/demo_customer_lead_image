using MediatR;

namespace Application.Image.Commands.ReplaceImage;

public sealed record ReplaceImageCommand : IRequest<ReplaceImageResponse>
{
    public required Guid LeadId { get; init; }
    public required Guid OldImageId { get; init; }
    public required string NewBase64Image { get; init; }
    public required string NewFileName { get; init; }
    public string? NewContentType { get; init; }
    public string? NewDescription { get; init; }
}