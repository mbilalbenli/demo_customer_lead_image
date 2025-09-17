using Application.Image.Commands.UploadImage;
using Domain.Common;
using Domain.Lead.Constants;
using Domain.Lead.Repositories;
using Domain.Lead.ValueObjects;
using Domain.Image.Entities;
using Domain.Image.Repositories;
using MediatR;

namespace Application.Image.Commands.BatchUploadImages;

public sealed class BatchUploadImagesCommandHandler : IRequestHandler<BatchUploadImagesCommand, BatchUploadImagesResponse>
{
    private readonly ILeadRepository _leadRepository;
    private readonly ILeadImageRepository _imageRepository;
    private readonly IUnitOfWork _unitOfWork;

    public BatchUploadImagesCommandHandler(
        ILeadRepository leadRepository,
        ILeadImageRepository imageRepository,
        IUnitOfWork unitOfWork)
    {
        _leadRepository = leadRepository;
        _imageRepository = imageRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<BatchUploadImagesResponse> Handle(BatchUploadImagesCommand request, CancellationToken cancellationToken)
    {
        var leadId = LeadId.From(request.LeadId);

        // Ensure lead exists
        var lead = await _leadRepository.GetByIdWithImagesAsync(leadId, cancellationToken);
        if (lead is null)
        {
            throw new KeyNotFoundException($"Lead with ID '{request.LeadId}' not found.");
        }

        // Count and capacity check
        var currentImageCount = await _leadRepository.GetImageCountAsync(leadId, cancellationToken);
        var availableSlots = LeadConstants.MAX_IMAGES_PER_LEAD - currentImageCount;
        if (availableSlots <= 0)
        {
            throw new ImageLimitReachedException(request.LeadId, currentImageCount);
        }

        // Clip items to available slots
        var itemsToProcess = request.Items.Take(availableSlots).ToList();

        var results = new List<BatchUploadItemResult>();
        var imagesToAdd = new List<LeadImage>();

        foreach (var item in itemsToProcess)
        {
            try
            {
                var image = LeadImage.CreateFromBase64(
                    request.LeadId,
                    item.Base64Image,
                    item.FileName,
                    item.ContentType,
                    item.Description
                );

                // domain validation via lead
                var addResult = lead.TryAddImage(image);
                if (!addResult.IsSuccess)
                {
                    results.Add(new BatchUploadItemResult
                    {
                        FileName = item.FileName,
                        Success = false,
                        ErrorCode = "DOMAIN_VALIDATION_FAILED",
                        ErrorMessage = addResult.Error ?? "Failed to add image to lead"
                    });
                    continue;
                }

                imagesToAdd.Add(image);
                results.Add(new BatchUploadItemResult
                {
                    ImageId = image.Id.Value,
                    FileName = item.FileName,
                    Success = true
                });
            }
            catch (Exception ex)
            {
                results.Add(new BatchUploadItemResult
                {
                    FileName = item.FileName,
                    Success = false,
                    ErrorCode = "INVALID_IMAGE",
                    ErrorMessage = ex.Message
                });
            }
        }

        // Persist valid images
        if (imagesToAdd.Count > 0)
        {
            await _imageRepository.AddRangeAsync(imagesToAdd, cancellationToken);
            await _leadRepository.UpdateAsync(lead, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);
        }

        var uploadedCount = results.Count(r => r.Success);
        var failedCount = results.Count - uploadedCount;
        var newCurrentCount = currentImageCount + uploadedCount;
        var remainingSlots = Math.Max(0, LeadConstants.MAX_IMAGES_PER_LEAD - newCurrentCount);

        return new BatchUploadImagesResponse
        {
            LeadId = request.LeadId.ToString(),
            UploadedCount = uploadedCount,
            FailedCount = failedCount,
            CurrentImageCount = newCurrentCount,
            RemainingSlots = remainingSlots,
            Results = results
        };
    }
}
