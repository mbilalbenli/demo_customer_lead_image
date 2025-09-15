using Backend.Application.HealthCheck.Queries;
using Backend.Domain.HealthCheck.Entities;
using Backend.Domain.HealthCheck.ValueObjects;
using Mapster;

namespace Backend.Application.HealthCheck.Mappings;

// Mapster configuration for mapping between domain entities and DTOs, centralizing all health check related type conversions
public class HealthCheckMappingConfig : IRegister
{
    public void Register(TypeAdapterConfig config)
    {
        config.NewConfig<ServiceStatus, ServiceStatusDto>()
            .Map(dest => dest.ResponseTimeMs, src => src.ResponseTime.TotalMilliseconds);

        config.NewConfig<SystemHealth, GetHealthCheckResponse>()
            .Map(dest => dest.Services, src => src.Services.Adapt<List<ServiceStatusDto>>());
    }
}