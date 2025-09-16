using Domain.Image.Constants;
using Domain.Lead.Constants;
using Domain.Lead.Repositories;
using Domain.Lead.ValueObjects;
using FluentValidation;

namespace Application.Image.Commands.UploadImage;

public sealed class UploadImageCommandValidator : AbstractValidator<UploadImageCommand>
{
    private readonly ILeadRepository _leadRepository;

    public UploadImageCommandValidator(ILeadRepository leadRepository)
    {
        _leadRepository = leadRepository;

        RuleFor(x => x.LeadId)
            .NotEmpty().WithMessage("Lead ID is required.")
            .MustAsync(LeadExists).WithMessage("Lead not found.");

        RuleFor(x => x.Base64Image)
            .NotEmpty().WithMessage("Image data is required.")
            .Must(BeValidBase64).WithMessage("Invalid Base64 image format.")
            .Must(BeWithinSizeLimit).WithMessage($"Image size exceeds maximum allowed size of {ImageConstants.MAX_IMAGE_SIZE_BYTES / 1048576}MB.");

        RuleFor(x => x.FileName)
            .NotEmpty().WithMessage("File name is required.")
            .MaximumLength(ImageConstants.MAX_FILE_NAME_LENGTH).WithMessage($"File name cannot exceed {ImageConstants.MAX_FILE_NAME_LENGTH} characters.")
            .Must(HaveValidExtension).WithMessage($"Invalid file extension. Allowed: {string.Join(", ", ImageConstants.ALLOWED_EXTENSIONS)}");

        RuleFor(x => x.ContentType)
            .Must(BeValidContentType).WithMessage($"Invalid content type. Allowed: {string.Join(", ", ImageConstants.ALLOWED_CONTENT_TYPES)}")
            .When(x => !string.IsNullOrWhiteSpace(x.ContentType));

        // CRITICAL: Check image count limit
        RuleFor(x => x)
            .MustAsync(async (command, cancellationToken) => await CanAddImage(command.LeadId, cancellationToken))
            .WithMessage((command) =>
            {
                var currentCount = GetCurrentImageCount(command.LeadId).GetAwaiter().GetResult();
                return $"Cannot add image. Lead already has {currentCount} image(s). " +
                       $"Maximum allowed is {LeadConstants.MAX_IMAGES_PER_LEAD}. " +
                       "Please delete an existing image before adding a new one or use the replace functionality.";
            })
            .WithErrorCode("ImageLimitReached");
    }

    private async Task<bool> LeadExists(Guid leadId, CancellationToken cancellationToken)
    {
        return await _leadRepository.ExistsAsync(LeadId.From(leadId), cancellationToken);
    }

    private async Task<bool> CanAddImage(Guid leadId, CancellationToken cancellationToken)
    {
        var currentCount = await _leadRepository.GetImageCountAsync(LeadId.From(leadId), cancellationToken);
        return currentCount < LeadConstants.MAX_IMAGES_PER_LEAD;
    }

    private async Task<int> GetCurrentImageCount(Guid leadId)
    {
        return await _leadRepository.GetImageCountAsync(LeadId.From(leadId), CancellationToken.None);
    }

    private bool BeValidBase64(string base64)
    {
        if (string.IsNullOrWhiteSpace(base64))
            return false;

        // Remove data URI if present
        if (base64.Contains(","))
        {
            base64 = base64.Substring(base64.IndexOf(",") + 1);
        }

        try
        {
            var bytes = Convert.FromBase64String(base64);
            return bytes.Length > 0;
        }
        catch
        {
            return false;
        }
    }

    private bool BeWithinSizeLimit(string base64)
    {
        if (string.IsNullOrWhiteSpace(base64))
            return false;

        // Remove data URI if present
        if (base64.Contains(","))
        {
            base64 = base64.Substring(base64.IndexOf(",") + 1);
        }

        // Calculate size
        var padding = 0;
        if (base64.EndsWith("==")) padding = 2;
        else if (base64.EndsWith("=")) padding = 1;

        var sizeInBytes = (base64.Length * 3) / 4 - padding;
        return sizeInBytes <= ImageConstants.MAX_IMAGE_SIZE_BYTES;
    }

    private bool HaveValidExtension(string fileName)
    {
        if (string.IsNullOrWhiteSpace(fileName))
            return false;

        var extension = Path.GetExtension(fileName).ToLowerInvariant();
        return ImageConstants.ALLOWED_EXTENSIONS.Contains(extension);
    }

    private bool BeValidContentType(string? contentType)
    {
        if (string.IsNullOrWhiteSpace(contentType))
            return true;

        return ImageConstants.ALLOWED_CONTENT_TYPES.Contains(contentType.ToLowerInvariant());
    }
}