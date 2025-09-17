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

        // If the image doesn't exist at all, surface 404 (idempotent delete semantics)
        if (!await _imageRepository.ExistsAsync(imageId, cancellationToken))
        {
            throw new KeyNotFoundException($"Image with ID '{request.ImageId}' not found.");
        }

        // Ensure lead exists (avoid 500 when lead is missing)
        var leadExists = await _leadRepository.ExistsAsync(leadId, cancellationToken);
        if (!leadExists)
        {
            throw new KeyNotFoundException($"Lead with ID '{request.LeadId}' not found.");
        }

        // Verify image belongs to lead (avoid leaking existence across leads)
        if (!await _imageRepository.BelongsToLeadAsync(imageId, leadId, cancellationToken))
        {
            // Treat as NotFound to avoid exposing cross‑lead existence
            throw new KeyNotFoundException($"Image with ID '{request.ImageId}' not found.");
        }

        // Delete image document from repository
        await _imageRepository.DeleteAsync(imageId, cancellationToken);

        // Persist changes
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        // Recompute counts from repository (source of truth)
        var remainingCount = await _imageRepository.GetCountByLeadIdAsync(leadId, cancellationToken);
        var availableSlots = LeadConstants.MAX_IMAGES_PER_LEAD - remainingCount;

        return new DeleteImageResponse
        {
            Success = true,
            RemainingImageCount = remainingCount,
            AvailableSlots = availableSlots,
            Message = $"Image deleted successfully. You now have {remainingCount} image(s) and can add {availableSlots} more."
        };
    }
}
