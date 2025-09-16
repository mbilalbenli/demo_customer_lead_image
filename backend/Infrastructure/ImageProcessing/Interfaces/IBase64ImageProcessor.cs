namespace Infrastructure.ImageProcessing.Interfaces;

public interface IBase64ImageProcessor
{
    Task<string> EncodeImageToBase64Async(byte[] imageBytes, CancellationToken cancellationToken = default);
    Task<byte[]> DecodeBase64ToImageAsync(string base64String, CancellationToken cancellationToken = default);
    Task<string> CompressAndEncodeAsync(byte[] imageBytes, int quality = 85, CancellationToken cancellationToken = default);
    bool ValidateBase64Format(string base64String);
    string GetImageFormatFromBase64(string base64String);
    int CalculateBase64Size(string base64String);
}