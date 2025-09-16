using Domain.Image.Repositories;
using Domain.Lead.Constants;
using Domain.Lead.ValueObjects;
using MediatR;

namespace Application.Image.Queries.GetImagesByLeadId;

public sealed class GetImagesByLeadIdQueryHandler : IRequestHandler<GetImagesByLeadIdQuery, LeadImagesResponse>
{
    private readonly ILeadImageRepository _imageRepository;

    public GetImagesByLeadIdQueryHandler(ILeadImageRepository imageRepository)
    {
        _imageRepository = imageRepository;
    }

    public async Task<LeadImagesResponse> Handle(GetImagesByLeadIdQuery request, CancellationToken cancellationToken)
    {
        var leadId = LeadId.From(request.LeadId);

        // Get total count first
        var totalCount = await _imageRepository.GetCountByLeadIdAsync(leadId, cancellationToken);

        // Get paged images
        var images = await _imageRepository.GetPagedByLeadIdAsync(
            leadId,
            request.PageNumber,
            request.PageSize,
            cancellationToken);

        // Map to response
        var imageDataList = images.Select(img => new ImageData
        {
            Id = img.Id.Value,
            FileName = img.Metadata.FileName,
            ContentType = img.Metadata.ContentType,
            Size = img.GetFormattedSize(),
            Base64Data = request.IncludeBase64Data ? img.GetBase64String() : null,
            DataUri = request.IncludeBase64Data ? img.GetDataUri() : null,
            UploadedAt = img.Metadata.UploadedAt,
            Description = img.Metadata.Description
        }).ToList();

        var totalPages = (int)Math.Ceiling(totalCount / (double)request.PageSize);
        var availableSlots = LeadConstants.MAX_IMAGES_PER_LEAD - totalCount;

        return new LeadImagesResponse
        {
            LeadId = request.LeadId,
            Images = imageDataList,
            TotalImageCount = totalCount,
            AvailableSlots = availableSlots,
            IsAtLimit = totalCount >= LeadConstants.MAX_IMAGES_PER_LEAD,
            PageNumber = request.PageNumber,
            PageSize = request.PageSize,
            TotalPages = totalPages
        };
    }
}