using MediatR;

namespace Application.Image.Queries.GetImageCount;

public sealed record GetImageCountQuery : IRequest<ImageCountResponse>
{
    public required Guid LeadId { get; init; }
}