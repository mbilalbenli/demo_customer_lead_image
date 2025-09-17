using MediatR;

namespace Application.Image.Queries.GetImagesByLeadId;

public sealed record GetImagesByLeadIdQuery : IRequest<LeadImagesResponse>
{
    public required Guid LeadId { get; init; }
    public bool IncludeBase64Data { get; init; } = true;
    public int PageNumber { get; init; } = 1;
    // Return all images by default to keep UI count in sync with limit (10)
    public int PageSize { get; init; } = 10;
}
