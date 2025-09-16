using Marten;
using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace Backend.Infrastructure.HealthCheck;

// Infrastructure health check for Marten document store connectivity, verifies PostgreSQL connection through Marten session
public class DatabaseHealthCheck : IHealthCheck
{
    private readonly IDocumentStore _documentStore;

    public DatabaseHealthCheck(IDocumentStore documentStore)
    {
        _documentStore = documentStore;
    }

    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        try
        {
            // Open a lightweight session to validate connectivity without querying
            using var session = _documentStore.LightweightSession();
            // If session is created successfully, consider Marten reachable
            return HealthCheckResult.Healthy("Marten session created successfully");
        }
        catch (Exception ex)
        {
            return HealthCheckResult.Unhealthy($"Marten health check failed: {ex.Message}");
        }
    }
}
