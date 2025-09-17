using MediatR;

namespace Application.Image.Commands.ValidateImage;

public sealed record ValidateImageCommand : IRequest<ValidateImageResponse>
{
    public required string Base64Image { get; init; }
    public required string FileName { get; init; }
    public string? ContentType { get; init; }
    public int? MaxSizeBytes { get; init; }
}

