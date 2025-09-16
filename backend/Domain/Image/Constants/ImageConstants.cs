namespace Domain.Image.Constants;

public static class ImageConstants
{
    public const int MAX_IMAGE_SIZE_BYTES = 5242880; // 5MB
    public const int MAX_FILE_NAME_LENGTH = 255;
    public const int MIN_BASE64_LENGTH = 100; // Minimum reasonable Base64 string
    public const string DEFAULT_CONTENT_TYPE = "image/jpeg";

    public static readonly string[] ALLOWED_CONTENT_TYPES =
    {
        "image/jpeg",
        "image/jpg",
        "image/png",
        "image/gif",
        "image/webp"
    };

    public static readonly string[] ALLOWED_EXTENSIONS =
    {
        ".jpg",
        ".jpeg",
        ".png",
        ".gif",
        ".webp"
    };
}