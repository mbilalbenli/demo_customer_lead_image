using Infrastructure.ImageProcessing.Interfaces;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Formats;
using SixLabors.ImageSharp.Formats.Jpeg;
using SixLabors.ImageSharp.Formats.Png;
using SixLabors.ImageSharp.Formats.Webp;
using SixLabors.ImageSharp.Processing;

namespace Infrastructure.ImageProcessing.Services;

public class Base64ImageProcessor : IBase64ImageProcessor
{
    private const int MAX_IMAGE_SIZE_BYTES = 5242880; // 5MB

    public Task<string> EncodeImageToBase64Async(byte[] imageBytes, CancellationToken cancellationToken = default)
    {
        if (imageBytes == null || imageBytes.Length == 0)
            throw new ArgumentException("Image bytes cannot be null or empty.", nameof(imageBytes));

        if (imageBytes.Length > MAX_IMAGE_SIZE_BYTES)
            throw new InvalidOperationException($"Image size {imageBytes.Length} exceeds maximum allowed size of {MAX_IMAGE_SIZE_BYTES} bytes.");

        return Task.FromResult(Convert.ToBase64String(imageBytes));
    }

    public Task<byte[]> DecodeBase64ToImageAsync(string base64String, CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrWhiteSpace(base64String))
            throw new ArgumentException("Base64 string cannot be null or empty.", nameof(base64String));

        // Remove data URI if present
        if (base64String.Contains(","))
        {
            base64String = base64String.Substring(base64String.IndexOf(",") + 1);
        }

        try
        {
            var bytes = Convert.FromBase64String(base64String);
            return Task.FromResult(bytes);
        }
        catch (FormatException ex)
        {
            throw new InvalidOperationException("Invalid Base64 format.", ex);
        }
    }

    public async Task<string> CompressAndEncodeAsync(byte[] imageBytes, int quality = 85, CancellationToken cancellationToken = default)
    {
        if (imageBytes.Length <= 1048576) // If less than 1MB, don't compress
        {
            return await EncodeImageToBase64Async(imageBytes, cancellationToken);
        }

        using var inputStream = new MemoryStream(imageBytes);
        using var outputStream = new MemoryStream();

        // Load image
        using var image = await Image.LoadAsync(inputStream, cancellationToken);

        // Resize if too large
        if (image.Width > 2048 || image.Height > 2048)
        {
            var ratio = Math.Min(2048.0 / image.Width, 2048.0 / image.Height);
            var newWidth = (int)(image.Width * ratio);
            var newHeight = (int)(image.Height * ratio);

            image.Mutate(x => x.Resize(newWidth, newHeight));
        }

        // Determine encoder based on format
        IImageEncoder encoder = GetEncoder(imageBytes, quality);

        // Save compressed image
        await image.SaveAsync(outputStream, encoder, cancellationToken);

        var compressedBytes = outputStream.ToArray();

        // Only use compressed if smaller
        if (compressedBytes.Length < imageBytes.Length)
        {
            return Convert.ToBase64String(compressedBytes);
        }

        return Convert.ToBase64String(imageBytes);
    }

    public bool ValidateBase64Format(string base64String)
    {
        if (string.IsNullOrWhiteSpace(base64String))
            return false;

        // Remove data URI if present
        if (base64String.Contains(","))
        {
            base64String = base64String.Substring(base64String.IndexOf(",") + 1);
        }

        try
        {
            var bytes = Convert.FromBase64String(base64String);
            return bytes.Length > 0;
        }
        catch
        {
            return false;
        }
    }

    public string GetImageFormatFromBase64(string base64String)
    {
        if (string.IsNullOrWhiteSpace(base64String))
            return "unknown";

        // Check for data URI
        if (base64String.StartsWith("data:image/"))
        {
            var startIndex = 11; // Length of "data:image/"
            var endIndex = base64String.IndexOf(';');
            if (endIndex > startIndex)
            {
                return base64String.Substring(startIndex, endIndex - startIndex);
            }
        }

        // Try to detect from binary signature
        try
        {
            var bytes = Convert.FromBase64String(base64String.Contains(",")
                ? base64String.Substring(base64String.IndexOf(",") + 1)
                : base64String);

            if (bytes.Length < 4) return "unknown";

            // Check common image signatures
            if (bytes[0] == 0xFF && bytes[1] == 0xD8) return "jpeg";
            if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) return "png";
            if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) return "gif";
            if (bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46) return "webp";
        }
        catch
        {
            // Ignore detection errors
        }

        return "unknown";
    }

    public int CalculateBase64Size(string base64String)
    {
        if (string.IsNullOrWhiteSpace(base64String))
            return 0;

        // Remove data URI if present
        if (base64String.Contains(","))
        {
            base64String = base64String.Substring(base64String.IndexOf(",") + 1);
        }

        // Calculate byte size from Base64 length
        var padding = 0;
        if (base64String.EndsWith("==")) padding = 2;
        else if (base64String.EndsWith("=")) padding = 1;

        return (base64String.Length * 3) / 4 - padding;
    }

    private IImageEncoder GetEncoder(byte[] imageBytes, int quality)
    {
        // Try to detect format
        using var ms = new MemoryStream(imageBytes);
        var format = Image.DetectFormat(ms);

        return format?.Name?.ToLower() switch
        {
            "png" => new PngEncoder(),
            "webp" => new WebpEncoder { Quality = quality },
            _ => new JpegEncoder { Quality = quality }
        };
    }
}