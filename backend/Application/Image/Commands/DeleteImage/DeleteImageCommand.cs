using MediatR;

namespace Application.Image.Commands.DeleteImage;

public sealed record DeleteImageCommand : IRequest<DeleteImageResponse>
{
    public required Guid LeadId { get; init; }
    public required Guid ImageId { get; init; }
}