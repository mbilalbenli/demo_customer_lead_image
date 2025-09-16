using MediatR;

namespace Application.Image.Queries.GetImagesByLeadId;

public sealed record GetImagesByLeadIdQuery : IRequest<LeadImagesResponse>
{
    public required Guid LeadId { get; init; }
    public bool IncludeBase64Data { get; init; } = true;
    public int PageNumber { get; init; } = 1;
    public int PageSize { get; init; } = 5; // Max 5 at a time to manage payload size
}