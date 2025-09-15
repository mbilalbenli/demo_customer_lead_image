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
            // Check Marten document store connectivity
            using var session = _documentStore.LightweightSession();

            // Execute a simple query to verify connection
            var count = await session.Query<object>().Take(0).CountAsync(cancellationToken);

            var dbName = session.Connection.Database;

            return HealthCheckResult.Healthy($"Marten connected to database: {dbName}");
        }
        catch (Exception ex)
        {
            return HealthCheckResult.Unhealthy($"Marten health check failed: {ex.Message}");
        }
    }
}