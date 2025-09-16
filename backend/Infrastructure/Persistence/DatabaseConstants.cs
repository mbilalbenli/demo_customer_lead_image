namespace Infrastructure.Persistence;

public static class DatabaseConstants
{
    public const string CONNECTION_STRING_NAME = "PostgreSQL";
    public const int COMMAND_TIMEOUT_SECONDS = 30;
    public const int MAX_RETRY_COUNT = 3;
    public const int CONNECTION_POOL_SIZE = 100;

    // Marten specific settings
    public const string SCHEMA_NAME = "lead_images";

    // Base64 storage settings
    public const int MAX_BASE64_COLUMN_LENGTH = 10485760; // 10MB to handle 5MB images with Base64 encoding overhead
}