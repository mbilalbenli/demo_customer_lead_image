namespace Backend.Domain.HealthCheck.ValueObjects;

// Value object representing the health status of an individual service component with immutable properties for status tracking
public record ServiceStatus
{
    public string Name { get; init; }
    public bool IsHealthy { get; init; }
    public string? Message { get; init; }
    public TimeSpan ResponseTime { get; init; }

    private ServiceStatus(string name, bool isHealthy, string? message, TimeSpan responseTime)
    {
        Name = name;
        IsHealthy = isHealthy;
        Message = message;
        ResponseTime = responseTime;
    }

    public static ServiceStatus Healthy(string name, TimeSpan responseTime)
        => new(name, true, "Service is running", responseTime);

    public static ServiceStatus Unhealthy(string name, string message, TimeSpan responseTime)
        => new(name, false, message, responseTime);
}