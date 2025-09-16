using Backend.Infrastructure.HealthCheck;
using Carter;
using Mapster;
using MapsterMapper;
using Marten;
using System.Reflection;
using Weasel.Core;

// Main entry point configuring DDD Clean Architecture with CQRS MediatR pattern, Mapster mapping, and Carter minimal APIs
var builder = WebApplication.CreateBuilder(args);

// Add services
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add MediatR
builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly()));

// Add Mapster
var config = TypeAdapterConfig.GlobalSettings;
config.Scan(Assembly.GetExecutingAssembly());
builder.Services.AddSingleton(config);
builder.Services.AddScoped<IMapper, ServiceMapper>();

// Add Carter
builder.Services.AddCarter();

// Configure Marten with PostgreSQL
var connectionString = builder.Configuration.GetConnectionString("PostgreSQL")
    ?? throw new InvalidOperationException("PostgreSQL connection string not found");

builder.Services.AddMarten(options =>
{
    options.Connection(connectionString);
    options.AutoCreateSchemaObjects = AutoCreate.CreateOrUpdate;

    // Configure document storage
    options.DatabaseSchemaName = "public";
})
.UseLightweightSessions()
.InitializeWith();

// Add Health Checks with PostgreSQL
builder.Services.AddHealthChecks()
    .AddNpgSql(connectionString, name: "postgresql", tags: new[] { "db", "sql" }, timeout: TimeSpan.FromSeconds(2));

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
