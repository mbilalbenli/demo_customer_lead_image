using Domain.Lead.Constants;
using Domain.Lead.Repositories;
using Domain.Lead.ValueObjects;
using Mapster;
using MediatR;

namespace Application.Lead.Queries.GetLeadById;

public sealed class GetLeadByIdQueryHandler : IRequestHandler<GetLeadByIdQuery, LeadDetailResponse>
{
    private readonly ILeadRepository _leadRepository;

    public GetLeadByIdQueryHandler(ILeadRepository leadRepository)
    {
        _leadRepository = leadRepository;
    }

    public async Task<LeadDetailResponse> Handle(GetLeadByIdQuery request, CancellationToken cancellationToken)
    {
        var leadId = LeadId.From(request.Id);

        // Get lead with or without images based on request
        var lead = request.IncludeImages
            ? await _leadRepository.GetByIdWithImagesAsync(leadId, cancellationToken)
            : await _leadRepository.GetByIdAsync(leadId, cancellationToken);

        if (lead == null)
        {
            throw new KeyNotFoundException($"Lead with ID '{request.Id}' not found.");
        }

        // Map basic lead data
        var response = lead.Adapt<LeadDetailResponse>();

        // Add computed properties
        var imageCount = lead.GetImageCount();
        var availableSlots = lead.GetAvailableImageSlots();

        var detailResponse = response with
        {
            Id = lead.Id.Value,
            ImageCount = imageCount,
            AvailableImageSlots = availableSlots,
            CanAddMoreImages = lead.CanAddImage()
        };

        // Map images if requested and available
        if (request.IncludeImages && lead.Images.Any())
        {
            detailResponse = detailResponse with
            {
                Images = lead.Images.Select(img => new ImageSummary
                {
                    Id = img.Id.Value,
                    FileName = img.Metadata.FileName,
                    ContentType = img.Metadata.ContentType,
                    Size = img.Size.GetFormatted(),
                    UploadedAt = img.Metadata.UploadedAt
                }).ToList()
            };
        }

        return detailResponse;
    }
}