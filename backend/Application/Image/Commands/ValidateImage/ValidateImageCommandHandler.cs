using Domain.Image.Constants;
using Application.Image.Interfaces;
using MediatR;

namespace Application.Image.Commands.ValidateImage;

public sealed class ValidateImageCommandHandler : IRequestHandler<ValidateImageCommand, ValidateImageResponse>
{
    private readonly IBase64ImageProcessor _processor;

    public ValidateImageCommandHandler(IBase64ImageProcessor processor)
    {
        _processor = processor;
    }

    public async Task<ValidateImageResponse> Handle(ValidateImageCommand request, CancellationToken cancellationToken)
    {
        try
        {
            var isBase64 = _processor.ValidateBase64Format(request.Base64Image);
            if (!isBase64)
            {
                return new ValidateImageResponse
                {
                    IsValid = false,
                    FileName = request.FileName,
                    DetectedContentType = "application/octet-stream",
                    SizeBytes = 0,
                    ExceedsLimit = false,
                    MaxAllowedBytes = request.MaxSizeBytes ?? ImageConstants.MAX_IMAGE_SIZE_BYTES,
                    SuggestCompression = false,
                    ErrorCode = "INVALID_BASE64",
                    ErrorMessage = "Provided data is not a valid Base64 string."
                };
            }

            var contentType = request.ContentType ?? _processor.GetImageFormatFromBase64(request.Base64Image);
            var size = _processor.CalculateBase64Size(request.Base64Image);
            var max = request.MaxSizeBytes ?? ImageConstants.MAX_IMAGE_SIZE_BYTES;

            var exceeds = size > max;
            var suggestCompression = size > (max * 0.6);

            var allowed = ImageConstants.ALLOWED_CONTENT_TYPES.Contains(contentType.ToLowerInvariant());

            if (!allowed)
            {
                return new ValidateImageResponse
                {
                    IsValid = false,
                    FileName = request.FileName,
                    DetectedContentType = contentType,
                    SizeBytes = size,
                    ExceedsLimit = exceeds,
                    MaxAllowedBytes = max,
                    SuggestCompression = suggestCompression,
                    ErrorCode = "UNSUPPORTED_TYPE",
                    ErrorMessage = $"ContentType '{contentType}' is not allowed."
                };
            }

            return new ValidateImageResponse
            {
                IsValid = !exceeds,
                FileName = request.FileName,
                DetectedContentType = contentType,
                SizeBytes = size,
                ExceedsLimit = exceeds,
                MaxAllowedBytes = max,
                SuggestCompression = suggestCompression,
            };
        }
        catch (Exception ex)
        {
            return new ValidateImageResponse
            {
                IsValid = false,
                FileName = request.FileName,
                DetectedContentType = request.ContentType ?? "application/octet-stream",
                SizeBytes = 0,
                ExceedsLimit = false,
                MaxAllowedBytes = request.MaxSizeBytes ?? ImageConstants.MAX_IMAGE_SIZE_BYTES,
                SuggestCompression = false,
                ErrorCode = "VALIDATION_ERROR",
                ErrorMessage = ex.Message
            };
        }
    }
}
