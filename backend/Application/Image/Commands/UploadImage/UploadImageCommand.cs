using MediatR;

namespace Application.Image.Commands.UploadImage;

public sealed record UploadImageCommand : IRequest<UploadImageResponse>
{
    public required Guid LeadId { get; init; }
    public required string Base64Image { get; init; }
    public required string FileName { get; init; }
    public string? ContentType { get; init; }
    public string? Description { get; init; }
}