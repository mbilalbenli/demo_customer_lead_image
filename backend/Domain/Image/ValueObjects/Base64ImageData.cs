using System.Text;
using System.Text.RegularExpressions;
using Domain.Image.Constants;
using Domain.Image.Exceptions;

namespace Domain.Image.ValueObjects;

public sealed partial class Base64ImageData : IEquatable<Base64ImageData>
{
    private static readonly Regex Base64Regex = GeneratedBase64Regex();
    private static readonly Regex DataUriRegex = GeneratedDataUriRegex();

    public string Value { get; }
    public int SizeInBytes { get; }

    private Base64ImageData(string base64Data)
    {
        if (string.IsNullOrWhiteSpace(base64Data))
            throw new ArgumentException("Base64 data cannot be empty.", nameof(base64Data));

        // Remove data URI scheme if present
        var cleanedData = ExtractBase64FromDataUri(base64Data);

        if (!IsValidBase64String(cleanedData))
            throw new InvalidBase64FormatException($"Invalid Base64 format. Data must be a valid Base64 encoded string.");

        // Calculate actual byte size
        var byteCount = CalculateByteSize(cleanedData);

        if (byteCount > ImageConstants.MAX_IMAGE_SIZE_BYTES)
            throw new ImageSizeLimitExceededException(byteCount);

        Value = cleanedData;
        SizeInBytes = byteCount;
    }

    public static Base64ImageData Create(string base64Data) => new(base64Data);

    public static Base64ImageData CreateFromBytes(byte[] bytes)
    {
        if (bytes == null || bytes.Length == 0)
            throw new ArgumentException("Byte array cannot be null or empty.", nameof(bytes));

        if (bytes.Length > ImageConstants.MAX_IMAGE_SIZE_BYTES)
            throw new ImageSizeLimitExceededException(bytes.Length);

        var base64String = Convert.ToBase64String(bytes);
        return new Base64ImageData(base64String);
    }

    public byte[] ToBytes()
    {
        try
        {
            return Convert.FromBase64String(Value);
        }
        catch (FormatException ex)
        {
            throw new InvalidBase64FormatException("Failed to convert Base64 to bytes.", ex);
        }
    }

    private static string ExtractBase64FromDataUri(string input)
    {
        if (string.IsNullOrWhiteSpace(input))
            return input;

        // Check if it's a data URI
        var match = DataUriRegex.Match(input);
        if (match.Success)
        {
            // Extract the Base64 part after the comma
            var commaIndex = input.IndexOf(',');
            if (commaIndex != -1 && commaIndex < input.Length - 1)
            {
                return input.Substring(commaIndex + 1);
            }
        }

        return input;
    }

    private static bool IsValidBase64String(string base64)
    {
        if (string.IsNullOrWhiteSpace(base64))
            return false;

        if (base64.Length < ImageConstants.MIN_BASE64_LENGTH)
            return false;

        // Check if it matches Base64 pattern
        if (!Base64Regex.IsMatch(base64))
            return false;

        // Verify it can be decoded
        try
        {
            Convert.FromBase64String(base64);
            return true;
        }
        catch
        {
            return false;
        }
    }

    private static int CalculateByteSize(string base64)
    {
        // Base64 encoding increases size by approximately 33%
        // Formula: bytes = (base64.Length * 3) / 4 - padding
        var padding = 0;
        if (base64.EndsWith("=="))
            padding = 2;
        else if (base64.EndsWith("="))
            padding = 1;

        return (base64.Length * 3) / 4 - padding;
    }

    public string GetSizeFormatted()
    {
        return SizeInBytes switch
        {
            < 1024 => $"{SizeInBytes} bytes",
            < 1048576 => $"{SizeInBytes / 1024.0:F2} KB",
            _ => $"{SizeInBytes / 1048576.0:F2} MB"
        };
    }

    public override bool Equals(object? obj) => obj is Base64ImageData other && Equals(other);

    public bool Equals(Base64ImageData? other) =>
        other is not null && Value.Equals(other.Value, StringComparison.Ordinal);

    public override int GetHashCode() => Value.GetHashCode();

    public override string ToString() => $"Base64 Image Data ({GetSizeFormatted()})";

    public static bool operator ==(Base64ImageData? left, Base64ImageData? right) => Equals(left, right);

    public static bool operator !=(Base64ImageData? left, Base64ImageData? right) => !Equals(left, right);

    [GeneratedRegex(@"^[A-Za-z0-9+/]*={0,2}$", RegexOptions.Compiled)]
    private static partial Regex GeneratedBase64Regex();

    [GeneratedRegex(@"^data:image/(jpeg|jpg|png|gif|webp);base64,", RegexOptions.Compiled | RegexOptions.IgnoreCase)]
    private static partial Regex GeneratedDataUriRegex();
}