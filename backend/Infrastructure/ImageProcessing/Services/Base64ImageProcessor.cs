using Application.Image.Interfaces;

namespace Infrastructure.ImageProcessing.Services;

public class Base64ImageProcessor : IBase64ImageProcessor
{
    public async Task<string> EncodeImageToBase64Async(byte[] imageBytes, CancellationToken cancellationToken = default)
    {
        return await Task.Run(() => Convert.ToBase64String(imageBytes), cancellationToken);
    }

    public async Task<byte[]> DecodeBase64ToImageAsync(string base64String, CancellationToken cancellationToken = default)
    {
        return await Task.Run(() => Convert.FromBase64String(base64String), cancellationToken);
    }

    public async Task<string> CompressAndEncodeAsync(byte[] imageBytes, int quality = 85, CancellationToken cancellationToken = default)
    {
        // For now, just encode without compression
        // In a real implementation, you would use an image processing library
        return await EncodeImageToBase64Async(imageBytes, cancellationToken);
    }

    public bool ValidateBase64Format(string base64String)
    {
        if (string.IsNullOrWhiteSpace(base64String))
            return false;

        try
        {
            var buffer = Convert.FromBase64String(base64String);
            return buffer.Length > 0;
        }
        catch
        {
            return false;
        }
    }

    public string GetImageFormatFromBase64(string base64String)
    {
        if (string.IsNullOrWhiteSpace(base64String))
            return "application/octet-stream";

        try
        {
            var buffer = Convert.FromBase64String(base64String.Substring(0, Math.Min(base64String.Length, 100)));

            // Check for common image signatures
            if (buffer.Length >= 2)
            {
                if (buffer[0] == 0xFF && buffer[1] == 0xD8)
                    return "image/jpeg";

                if (buffer[0] == 0x89 && buffer[1] == 0x50)
                    return "image/png";

                if (buffer[0] == 0x47 && buffer[1] == 0x49)
                    return "image/gif";

                if (buffer[0] == 0x42 && buffer[1] == 0x4D)
                    return "image/bmp";
            }
        }
        catch
        {
            // Ignore errors and return default
        }

        return "application/octet-stream";
    }

    public int CalculateBase64Size(string base64String)
    {
        if (string.IsNullOrWhiteSpace(base64String))
            return 0;

        var padding = base64String.EndsWith("==") ? 2 : base64String.EndsWith("=") ? 1 : 0;
        return (base64String.Length * 3 / 4) - padding;
    }
}
