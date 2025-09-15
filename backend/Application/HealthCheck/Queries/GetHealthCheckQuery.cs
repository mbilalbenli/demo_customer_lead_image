using MediatR;

namespace Backend.Application.HealthCheck.Queries;

// CQRS query for retrieving system health status, follows MediatR request/response pattern for clean separation of concerns
public record GetHealthCheckQuery : IRequest<GetHealthCheckResponse>;

public record GetHealthCheckResponse(
    bool IsHealthy,
    string Status,
    DateTime CheckedAt,
    string Version,
    TimeSpan Uptime,
    List<ServiceStatusDto> Services);

public record ServiceStatusDto(
    string Name,
    bool IsHealthy,
    string? Message,
    double ResponseTimeMs);