using Backend.Domain.HealthCheck.ValueObjects;

namespace Backend.Domain.HealthCheck.Entities;

// Domain entity that aggregates overall system health status including all service checks, uptime metrics, and version information
public class SystemHealth
{
    public Guid Id { get; private set; }
    public DateTime CheckedAt { get; private set; }
    public bool IsHealthy { get; private set; }
    public string Status { get; private set; } = string.Empty;
    public string Version { get; private set; } = string.Empty;
    public TimeSpan Uptime { get; private set; }
    public List<ServiceStatus> Services { get; private set; }

    private SystemHealth()
    {
        Services = new List<ServiceStatus>();
    }

    public static SystemHealth Create(
        string version,
        TimeSpan uptime,
        List<ServiceStatus> services)
    {
        var health = new SystemHealth
        {
            Id = Guid.NewGuid(),
            CheckedAt = DateTime.UtcNow,
            Version = version,
            Uptime = uptime,
            Services = services ?? new List<ServiceStatus>()
        };

        health.UpdateHealthStatus();
        return health;
    }

    private void UpdateHealthStatus()
    {
        IsHealthy = Services.All(s => s.IsHealthy);
        Status = IsHealthy ? "Healthy" : "Degraded";
    }
}