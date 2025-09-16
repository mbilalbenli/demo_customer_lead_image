using Domain.Image.Constants;
using Domain.Image.Exceptions;
using Domain.Image.ValueObjects;
using Domain.Lead.ValueObjects;

namespace Domain.Image.Entities;

public sealed class LeadImage
{
    // Private constructor for encapsulation
    private LeadImage(
        ImageId id,
        LeadId leadId,
        Base64ImageData base64Data,
        ImageMetadata metadata,
        ImageSize size,
        DateTime createdAt,
        DateTime? modifiedAt = null)
    {
        Id = id;
        LeadId = leadId;
        Base64Data = base64Data;
        Metadata = metadata;
        Size = size;
        CreatedAt = createdAt;
        ModifiedAt = modifiedAt;
    }

    public ImageId Id { get; private set; }
    public LeadId LeadId { get; private set; }
    public Base64ImageData Base64Data { get; private set; }
    public ImageMetadata Metadata { get; private set; }
    public ImageSize Size { get; private set; }
    public DateTime CreatedAt { get; private set; }
    public DateTime? ModifiedAt { get; private set; }

    // Factory method for creating new images from Base64 string
    public static LeadImage CreateFromBase64(
        Guid leadId,
        string base64Data,
        string fileName,
        string? contentType = null,
        string? description = null)
    {
        var base64Value = Base64ImageData.Create(base64Data);
        var metadata = contentType != null
            ? ImageMetadata.Create(fileName, contentType, DateTime.UtcNow, description)
            : ImageMetadata.CreateFromFileName(fileName, DateTime.UtcNow, description);

        var size = ImageSize.Create(base64Value.SizeInBytes);

        return new LeadImage(
            ImageId.Create(),
            LeadId.From(leadId),
            base64Value,
            metadata,
            size,
            DateTime.UtcNow
        );
    }

    // Factory method for creating images from byte array
    public static LeadImage CreateFromBytes(
        Guid leadId,
        byte[] imageBytes,
        string fileName,
        string? contentType = null,
        string? description = null)
    {
        if (imageBytes == null || imageBytes.Length == 0)
            throw new ArgumentException("Image bytes cannot be null or empty.", nameof(imageBytes));

        if (imageBytes.Length > ImageConstants.MAX_IMAGE_SIZE_BYTES)
            throw new ImageSizeLimitExceededException(imageBytes.Length);

        var base64Value = Base64ImageData.CreateFromBytes(imageBytes);
        var metadata = contentType != null
            ? ImageMetadata.Create(fileName, contentType, DateTime.UtcNow, description)
            : ImageMetadata.CreateFromFileName(fileName, DateTime.UtcNow, description);

        var size = ImageSize.Create(imageBytes.Length);

        return new LeadImage(
            ImageId.Create(),
            LeadId.From(leadId),
            base64Value,
            metadata,
            size,
            DateTime.UtcNow
        );
    }

    // Factory method for reconstitution from persistence
    public static LeadImage Reconstitute(
        Guid id,
        Guid leadId,
        string base64Data,
        string fileName,
        string contentType,
        int sizeInBytes,
        DateTime uploadedAt,
        DateTime createdAt,
        DateTime? modifiedAt = null,
        string? description = null)
    {
        return new LeadImage(
            ImageId.From(id),
            LeadId.From(leadId),
            Base64ImageData.Create(base64Data),
            ImageMetadata.Create(fileName, contentType, uploadedAt, description),
            ImageSize.Create(sizeInBytes),
            createdAt,
            modifiedAt
        );
    }

    // Business methods
    public bool IsValidBase64()
    {
        try
        {
            var bytes = Base64Data.ToBytes();
            return bytes != null && bytes.Length > 0;
        }
        catch
        {
            return false;
        }
    }

    public byte[] GetImageBytes()
    {
        return Base64Data.ToBytes();
    }

    public string GetBase64String()
    {
        return Base64Data.Value;
    }

    public string GetDataUri()
    {
        return $"data:{Metadata.ContentType};base64,{Base64Data.Value}";
    }

    public void UpdateDescription(string? description)
    {
        Metadata = ImageMetadata.Create(
            Metadata.FileName,
            Metadata.ContentType,
            Metadata.UploadedAt,
            description
        );
        ModifiedAt = DateTime.UtcNow;
    }

    public bool IsImage()
    {
        return ImageConstants.ALLOWED_CONTENT_TYPES.Contains(Metadata.ContentType.ToLowerInvariant());
    }

    public bool ExceedsSizeLimit(int? customLimitBytes = null)
    {
        var limit = customLimitBytes ?? ImageConstants.MAX_IMAGE_SIZE_BYTES;
        return Size.SizeInBytes > limit;
    }

    public string GetFormattedSize()
    {
        return Size.GetFormatted();
    }

    public override string ToString()
    {
        return $"Image: {Metadata.FileName} ({GetFormattedSize()}) - Lead: {LeadId}";
    }
}