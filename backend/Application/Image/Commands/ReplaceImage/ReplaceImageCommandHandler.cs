using Domain.Common;
using Domain.Image.Entities;
using Domain.Image.Repositories;
using Domain.Image.ValueObjects;
using Domain.Lead.Repositories;
using Domain.Lead.ValueObjects;
using MediatR;

namespace Application.Image.Commands.ReplaceImage;

public sealed class ReplaceImageCommandHandler : IRequestHandler<ReplaceImageCommand, ReplaceImageResponse>
{
    private readonly ILeadRepository _leadRepository;
    private readonly ILeadImageRepository _imageRepository;
    private readonly IUnitOfWork _unitOfWork;

    public ReplaceImageCommandHandler(
        ILeadRepository leadRepository,
        ILeadImageRepository imageRepository,
        IUnitOfWork unitOfWork)
    {
        _leadRepository = leadRepository;
        _imageRepository = imageRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<ReplaceImageResponse> Handle(ReplaceImageCommand request, CancellationToken cancellationToken)
    {
        var leadId = LeadId.From(request.LeadId);
        var oldImageId = ImageId.From(request.OldImageId);

        // Verify old image belongs to lead
        if (!await _imageRepository.BelongsToLeadAsync(oldImageId, leadId, cancellationToken))
        {
            throw new InvalidOperationException($"Image {request.OldImageId} does not belong to lead {request.LeadId}");
        }

        // Get lead with images
        var lead = await _leadRepository.GetByIdWithImagesAsync(leadId, cancellationToken);
        if (lead == null)
        {
            throw new KeyNotFoundException($"Lead with ID '{request.LeadId}' not found.");
        }

        // Create new image
        var newImage = LeadImage.CreateFromBase64(
            request.LeadId,
            request.NewBase64Image,
            request.NewFileName,
            request.NewContentType,
            request.NewDescription
        );

        // Replace in lead (atomic operation)
        var result = lead.ReplaceImage(request.OldImageId, newImage);
        if (!result.IsSuccess)
        {
            throw new InvalidOperationException(result.Error ?? "Failed to replace image.");
        }

        // Replace in repository
        await _imageRepository.ReplaceAsync(oldImageId, newImage, cancellationToken);

        // Update lead
        await _leadRepository.UpdateAsync(lead, cancellationToken);

        // Save changes
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return new ReplaceImageResponse
        {
            OldImageId = request.OldImageId,
            NewImageId = newImage.Id.Value,
            LeadId = request.LeadId,
            FileName = newImage.Metadata.FileName,
            Size = newImage.GetFormattedSize(),
            Message = "Image replaced successfully. Image count remains at the limit."
        };
    }
}