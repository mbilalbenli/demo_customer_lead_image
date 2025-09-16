using Backend.Application.HealthCheck.Queries;
using Carter;
using MediatR;
using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace Backend.API.Modules;

// Carter module defining health check API endpoints using minimal API pattern with MediatR for clean request handling
public class HealthCheckModule : ICarterModule
{
    public void AddRoutes(IEndpointRouteBuilder app)
    {
        app.MapGet("/api/health", async (IMediator mediator) =>
        {
            var query = new GetHealthCheckQuery();
            var result = await mediator.Send(query);

            return Results.Ok(result);
        })
    .WithTags("Health")
    .Produces<GetHealthCheckResponse>(200);

        app.MapGet("/api/health/live", () => Results.Ok(new { status = "alive" }))
            .WithTags("Health")
            .ExcludeFromDescription();

        app.MapGet("/api/health/ready", async (HealthCheckService healthCheckService) =>
        {
            var result = await healthCheckService.CheckHealthAsync();
            return result.Status == HealthStatus.Healthy
                ? Results.Ok(new { status = "ready" })
                : Results.Json(new { status = "not ready" }, statusCode: 503);
        })
    .WithTags("Health")
    .ExcludeFromDescription();
    }
}
