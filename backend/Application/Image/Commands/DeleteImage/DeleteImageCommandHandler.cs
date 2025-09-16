using Domain.Common;
using Domain.Image.Repositories;
using Domain.Image.ValueObjects;
using Domain.Lead.Constants;
using Domain.Lead.Repositories;
using Domain.Lead.ValueObjects;
using MediatR;

namespace Application.Image.Commands.DeleteImage;

public sealed class DeleteImageCommandHandler : IRequestHandler<DeleteImageCommand, DeleteImageResponse>
{
    private readonly ILeadRepository _leadRepository;
    private readonly ILeadImageRepository _imageRepository;
    private readonly IUnitOfWork _unitOfWork;

    public DeleteImageCommandHandler(
        ILeadRepository leadRepository,
        ILeadImageRepository imageRepository,
        IUnitOfWork unitOfWork)
    {
        _leadRepository = leadRepository;
        _imageRepository = imageRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<DeleteImageResponse> Handle(DeleteImageCommand request, CancellationToken cancellationToken)
    {
        var leadId = LeadId.From(request.LeadId);
        var imageId = ImageId.From(request.ImageId);

        // Verify image belongs to lead
        if (!await _imageRepository.BelongsToLeadAsync(imageId, leadId, cancellationToken))
        {
            throw new InvalidOperationException($"Image {request.ImageId} does not belong to lead {request.LeadId}");
        }

        // Get lead with images
        var lead = await _leadRepository.GetByIdWithImagesAsync(leadId, cancellationToken);
        if (lead == null)
        {
            throw new KeyNotFoundException($"Lead with ID '{request.LeadId}' not found.");
        }

        // Remove image from lead
        var result = lead.RemoveImage(request.ImageId);
        if (!result.IsSuccess)
        {
            throw new InvalidOperationException(result.Error ?? "Failed to remove image.");
        }

        // Delete from repository
        await _imageRepository.DeleteAsync(imageId, cancellationToken);

        // Update lead
        await _leadRepository.UpdateAsync(lead, cancellationToken);

        // Save changes
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        var remainingCount = lead.GetImageCount();
        var availableSlots = lead.GetAvailableImageSlots();

        return new DeleteImageResponse
        {
            Success = true,
            RemainingImageCount = remainingCount,
            AvailableSlots = availableSlots,
            Message = $"Image deleted successfully. You now have {remainingCount} image(s) and can add {availableSlots} more."
        };
    }
}