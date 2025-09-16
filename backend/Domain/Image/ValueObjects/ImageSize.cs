using Domain.Image.Constants;

namespace Domain.Image.ValueObjects;

public sealed class ImageSize : IEquatable<ImageSize>
{
    public int SizeInBytes { get; }

    private ImageSize(int sizeInBytes)
    {
        if (sizeInBytes <= 0)
            throw new ArgumentException("Image size must be greater than zero.", nameof(sizeInBytes));

        if (sizeInBytes > ImageConstants.MAX_IMAGE_SIZE_BYTES)
            throw new ArgumentException($"Image size {sizeInBytes} bytes exceeds maximum allowed size of {ImageConstants.MAX_IMAGE_SIZE_BYTES} bytes.", nameof(sizeInBytes));

        SizeInBytes = sizeInBytes;
    }

    public static ImageSize Create(int sizeInBytes) => new(sizeInBytes);

    public static ImageSize FromBase64Length(int base64Length)
    {
        // Calculate byte size from Base64 string length
        var padding = 0;

        // This is approximate since we don't have the actual string to check padding
        // Base64 encoding increases size by approximately 33%
        var estimatedBytes = (base64Length * 3) / 4;

        return new ImageSize(estimatedBytes);
    }

    public double GetSizeInKB() => SizeInBytes / 1024.0;

    public double GetSizeInMB() => SizeInBytes / 1048576.0;

    public string GetFormatted()
    {
        return SizeInBytes switch
        {
            < 1024 => $"{SizeInBytes} bytes",
            < 1048576 => $"{GetSizeInKB():F2} KB",
            _ => $"{GetSizeInMB():F2} MB"
        };
    }

    public bool IsWithinLimit(int maxSizeInBytes = ImageConstants.MAX_IMAGE_SIZE_BYTES)
    {
        return SizeInBytes <= maxSizeInBytes;
    }

    public override bool Equals(object? obj) => obj is ImageSize other && Equals(other);

    public bool Equals(ImageSize? other) => other is not null && SizeInBytes == other.SizeInBytes;

    public override int GetHashCode() => SizeInBytes.GetHashCode();

    public override string ToString() => GetFormatted();

    public static implicit operator int(ImageSize size) => size.SizeInBytes;

    public static bool operator ==(ImageSize? left, ImageSize? right) => Equals(left, right);

    public static bool operator !=(ImageSize? left, ImageSize? right) => !Equals(left, right);

    public static bool operator <(ImageSize left, ImageSize right) => left.SizeInBytes < right.SizeInBytes;

    public static bool operator >(ImageSize left, ImageSize right) => left.SizeInBytes > right.SizeInBytes;

    public static bool operator <=(ImageSize left, ImageSize right) => left.SizeInBytes <= right.SizeInBytes;

    public static bool operator >=(ImageSize left, ImageSize right) => left.SizeInBytes >= right.SizeInBytes;
}