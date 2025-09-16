using Domain.Image.Repositories;
using Domain.Lead.Constants;
using Domain.Lead.ValueObjects;
using MediatR;

namespace Application.Image.Queries.GetImageCount;

public sealed class GetImageCountQueryHandler : IRequestHandler<GetImageCountQuery, ImageCountResponse>
{
    private readonly ILeadImageRepository _imageRepository;

    public GetImageCountQueryHandler(ILeadImageRepository imageRepository)
    {
        _imageRepository = imageRepository;
    }

    public async Task<ImageCountResponse> Handle(GetImageCountQuery request, CancellationToken cancellationToken)
    {
        var leadId = LeadId.From(request.LeadId);
        var currentCount = await _imageRepository.GetCountByLeadIdAsync(leadId, cancellationToken);
        var availableSlots = LeadConstants.MAX_IMAGES_PER_LEAD - currentCount;

        var statusMessage = availableSlots switch
        {
            0 => "Storage full - Delete an image to add more",
            1 => "1 slot remaining",
            _ => $"{availableSlots} slots available"
        };

        return new ImageCountResponse
        {
            LeadId = request.LeadId,
            CurrentCount = currentCount,
            MaxCount = LeadConstants.MAX_IMAGES_PER_LEAD,
            AvailableSlots = availableSlots,
            CanAddMore = availableSlots > 0,
            StatusMessage = statusMessage
        };
    }
}