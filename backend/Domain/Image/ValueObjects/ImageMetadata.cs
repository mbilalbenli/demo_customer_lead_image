using Domain.Image.Constants;

namespace Domain.Image.ValueObjects;

public sealed class ImageMetadata : IEquatable<ImageMetadata>
{
    public string FileName { get; }
    public string ContentType { get; }
    public DateTime UploadedAt { get; }
    public string? Description { get; }

    private ImageMetadata(string fileName, string contentType, DateTime uploadedAt, string? description = null)
    {
        if (string.IsNullOrWhiteSpace(fileName))
            throw new ArgumentException("File name cannot be empty.", nameof(fileName));

        if (fileName.Length > ImageConstants.MAX_FILE_NAME_LENGTH)
            throw new ArgumentException($"File name cannot exceed {ImageConstants.MAX_FILE_NAME_LENGTH} characters.", nameof(fileName));

        if (string.IsNullOrWhiteSpace(contentType))
            throw new ArgumentException("Content type cannot be empty.", nameof(contentType));

        if (!ImageConstants.ALLOWED_CONTENT_TYPES.Contains(contentType.ToLowerInvariant()))
            throw new ArgumentException($"Content type '{contentType}' is not allowed. Allowed types: {string.Join(", ", ImageConstants.ALLOWED_CONTENT_TYPES)}", nameof(contentType));

        FileName = fileName.Trim();
        ContentType = contentType.ToLowerInvariant();
        UploadedAt = uploadedAt;
        Description = description?.Trim();
    }

    public static ImageMetadata Create(string fileName, string contentType, DateTime? uploadedAt = null, string? description = null)
    {
        return new ImageMetadata(
            fileName,
            contentType,
            uploadedAt ?? DateTime.UtcNow,
            description
        );
    }

    public static ImageMetadata CreateFromFileName(string fileName, DateTime? uploadedAt = null, string? description = null)
    {
        var extension = Path.GetExtension(fileName).ToLowerInvariant();
        var contentType = extension switch
        {
            ".jpg" or ".jpeg" => "image/jpeg",
            ".png" => "image/png",
            ".gif" => "image/gif",
            ".webp" => "image/webp",
            _ => ImageConstants.DEFAULT_CONTENT_TYPE
        };

        return new ImageMetadata(
            fileName,
            contentType,
            uploadedAt ?? DateTime.UtcNow,
            description
        );
    }

    public string GetFileExtension()
    {
        return ContentType switch
        {
            "image/jpeg" or "image/jpg" => ".jpg",
            "image/png" => ".png",
            "image/gif" => ".gif",
            "image/webp" => ".webp",
            _ => ".jpg"
        };
    }

    public override bool Equals(object? obj) => obj is ImageMetadata other && Equals(other);

    public bool Equals(ImageMetadata? other)
    {
        if (other is null) return false;
        return FileName.Equals(other.FileName, StringComparison.OrdinalIgnoreCase) &&
               ContentType.Equals(other.ContentType, StringComparison.OrdinalIgnoreCase) &&
               UploadedAt == other.UploadedAt;
    }

    public override int GetHashCode() => HashCode.Combine(FileName.ToLowerInvariant(), ContentType, UploadedAt);

    public override string ToString() => $"{FileName} ({ContentType})";
}