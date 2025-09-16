using Domain.Image.Constants;

namespace Domain.Image.Exceptions;

public class ImageSizeLimitExceededException : DomainException
{
    public int ActualSizeInBytes { get; }
    public int MaxSizeInBytes { get; }

    public ImageSizeLimitExceededException(int actualSizeInBytes)
        : base($"Image size {actualSizeInBytes} bytes exceeds maximum allowed size of {ImageConstants.MAX_IMAGE_SIZE_BYTES} bytes ({ImageConstants.MAX_IMAGE_SIZE_BYTES / 1048576}MB).")
    {
        ActualSizeInBytes = actualSizeInBytes;
        MaxSizeInBytes = ImageConstants.MAX_IMAGE_SIZE_BYTES;
    }

    public ImageSizeLimitExceededException(int actualSizeInBytes, int maxSizeInBytes)
        : base($"Image size {actualSizeInBytes} bytes exceeds maximum allowed size of {maxSizeInBytes} bytes.")
    {
        ActualSizeInBytes = actualSizeInBytes;
        MaxSizeInBytes = maxSizeInBytes;
    }
}