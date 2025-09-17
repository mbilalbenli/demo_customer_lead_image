using Backend.Infrastructure.HealthCheck;
using Carter;
using Domain.Image.Repositories;
using Domain.Lead.Repositories;
using FluentValidation;
using Application.Image.Interfaces;
using Infrastructure.ImageProcessing.Services;
using Infrastructure.Persistence.Repositories;
using Mapster;
using MapsterMapper;
using Marten;
using System.Reflection;
using Weasel.Core;
using Application.Lead.Commands.CreateLead;
using Microsoft.Extensions.DependencyInjection.Extensions;

// Main entry point configuring DDD Clean Architecture with CQRS MediatR pattern, Mapster mapping, and Carter minimal APIs
var builder = WebApplication.CreateBuilder(args);

// Add services
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add MediatR - Register from Application assembly where handlers are defined
builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(CreateLeadCommand).Assembly));

// Add FluentValidation - Register validators as Scoped to match repository lifetime
builder.Services.AddValidatorsFromAssembly(typeof(CreateLeadCommand).Assembly, ServiceLifetime.Scoped);

// Add Mapster
var config = TypeAdapterConfig.GlobalSettings;
// Scan both API (host) and Application assemblies so mapping configurations in Application are loaded
config.Scan(Assembly.GetExecutingAssembly());
config.Scan(typeof(CreateLeadCommand).Assembly);
// Configure custom mappings AFTER scanning to ensure they override defaults
Infrastructure.Persistence.MappingConfiguration.Configure();
builder.Services.AddSingleton(config);
builder.Services.AddScoped<IMapper, ServiceMapper>();

// Configure Marten with PostgreSQL FIRST (needed by repositories)
var martenConnectionString = builder.Configuration.GetConnectionString("PostgreSQL")
    ?? throw new InvalidOperationException("PostgreSQL connection string not found");

builder.Services.AddMarten(options =>
{
    options.Connection(martenConnectionString);
    // Auto-create database schema objects
    options.DatabaseSchemaName = "public";
})
.UseLightweightSessions();

// Add Repositories and Services (needed by validators)
builder.Services.AddScoped<ILeadRepository, LeadRepository>();
builder.Services.AddScoped<ILeadImageRepository, LeadImageRepository>();
builder.Services.AddSingleton<IBase64ImageProcessor, Base64ImageProcessor>();
builder.Services.AddScoped<Domain.Common.IUnitOfWork, Infrastructure.Persistence.UnitOfWork>();

// Add Carter (after repositories are registered)
builder.Services.AddCarter();

// Add Health Checks with PostgreSQL
builder.Services.AddHealthChecks()
    .AddNpgSql(martenConnectionString, name: "postgresql", tags: new[] { "db", "sql" }, timeout: TimeSpan.FromSeconds(2));

var app = builder.Build();

// Configure pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHealthChecks("/health");
app.MapCarter();

app.Run();
