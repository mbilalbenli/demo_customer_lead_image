using Domain.Common;
using Domain.Image.Entities;
using Domain.Image.Repositories;
using Domain.Lead.Constants;
using Domain.Lead.Repositories;
using Domain.Lead.ValueObjects;
using MediatR;

namespace Application.Image.Commands.UploadImage;

public sealed class UploadImageCommandHandler : IRequestHandler<UploadImageCommand, UploadImageResponse>
{
    private readonly ILeadRepository _leadRepository;
    private readonly ILeadImageRepository _imageRepository;
    private readonly IUnitOfWork _unitOfWork;

    public UploadImageCommandHandler(
        ILeadRepository leadRepository,
        ILeadImageRepository imageRepository,
        IUnitOfWork unitOfWork)
    {
        _leadRepository = leadRepository;
        _imageRepository = imageRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<UploadImageResponse> Handle(UploadImageCommand request, CancellationToken cancellationToken)
    {
        var leadId = LeadId.From(request.LeadId);

        // Check if lead exists first
        var leadExists = await _leadRepository.ExistsAsync(leadId, cancellationToken);
        if (!leadExists)
        {
            throw new KeyNotFoundException($"Lead with ID '{request.LeadId}' not found.");
        }

        // CRITICAL: Double-check image count before proceeding
        var currentImageCount = await _leadRepository.GetImageCountAsync(leadId, cancellationToken);

        if (currentImageCount >= LeadConstants.MAX_IMAGES_PER_LEAD)
        {
            throw new ImageLimitReachedException(request.LeadId, currentImageCount);
        }

        // Get the lead with images
        var lead = await _leadRepository.GetByIdWithImagesAsync(leadId, cancellationToken);
        if (lead == null)
        {
            throw new KeyNotFoundException($"Lead with ID '{request.LeadId}' not found.");
        }

        // Create the image entity from Base64
        var image = LeadImage.CreateFromBase64(
            request.LeadId,
            request.Base64Image,
            request.FileName,
            request.ContentType,
            request.Description
        );

        // Try to add image to lead (domain validation)
        var result = lead.TryAddImage(image);
        if (!result.IsSuccess)
        {
            // This is a safety net - validator should have caught this
            throw new InvalidOperationException(result.Error ?? "Failed to add image to lead.");
        }

        // Save image to repository
        await _imageRepository.AddAsync(image, cancellationToken);

        // Update lead
        await _leadRepository.UpdateAsync(lead, cancellationToken);

        // Save changes
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        // Calculate updated counts
        var newImageCount = currentImageCount + 1;
        var remainingSlots = LeadConstants.MAX_IMAGES_PER_LEAD - newImageCount;
        var isAtLimit = newImageCount >= LeadConstants.MAX_IMAGES_PER_LEAD;

        // Build response with helpful information
        var response = new UploadImageResponse
        {
            ImageId = image.Id.Value,
            LeadId = request.LeadId,
            FileName = image.Metadata.FileName,
            ContentType = image.Metadata.ContentType,
            Size = image.GetFormattedSize(),
            CurrentImageCount = newImageCount,
            RemainingSlots = remainingSlots,
            IsAtLimit = isAtLimit,
            UploadedAt = image.Metadata.UploadedAt
        };

        // Add suggestion message based on remaining slots
        response = response with
        {
            SuggestionMessage = remainingSlots switch
            {
                0 => "You've reached the maximum of 10 images. To add more, you'll need to delete or replace existing images.",
                1 => "You can add 1 more image before reaching the limit.",
                2 => "You have room for 2 more images.",
                _ => $"You can add {remainingSlots} more images."
            }
        };

        return response;
    }
}