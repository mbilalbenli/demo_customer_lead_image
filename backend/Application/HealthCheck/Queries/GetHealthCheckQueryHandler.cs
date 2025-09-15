using Backend.Domain.HealthCheck.Entities;
using Backend.Domain.HealthCheck.ValueObjects;
using Mapster;
using MediatR;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using System.Diagnostics;
using System.Reflection;

namespace Backend.Application.HealthCheck.Queries;

// MediatR handler that orchestrates health checks, creates domain entities, and maps responses using Mapster for clean data transformation
public class GetHealthCheckQueryHandler : IRequestHandler<GetHealthCheckQuery, GetHealthCheckResponse>
{
    private readonly HealthCheckService _healthCheckService;
    private static readonly DateTime _startTime = DateTime.UtcNow;

    public GetHealthCheckQueryHandler(HealthCheckService healthCheckService)
    {
        _healthCheckService = healthCheckService;
    }

    public async Task<GetHealthCheckResponse> Handle(GetHealthCheckQuery request, CancellationToken cancellationToken)
    {
        var stopwatch = Stopwatch.StartNew();
        var healthReport = await _healthCheckService.CheckHealthAsync(cancellationToken);
        stopwatch.Stop();

        var services = new List<ServiceStatus>();

        services.Add(ServiceStatus.Healthy("API", stopwatch.Elapsed));

        foreach (var entry in healthReport.Entries)
        {
            if (entry.Value.Status == HealthStatus.Healthy)
            {
                services.Add(ServiceStatus.Healthy(entry.Key, entry.Value.Duration));
            }
            else
            {
                services.Add(ServiceStatus.Unhealthy(
                    entry.Key,
                    entry.Value.Description ?? "Service unavailable",
                    entry.Value.Duration));
            }
        }

        var version = Assembly.GetExecutingAssembly().GetName().Version?.ToString() ?? "1.0.0";
        var uptime = DateTime.UtcNow - _startTime;

        var systemHealth = SystemHealth.Create(version, uptime, services);

        return systemHealth.Adapt<GetHealthCheckResponse>();
    }
}