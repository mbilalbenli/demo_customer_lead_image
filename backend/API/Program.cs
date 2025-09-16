using Carter;
using FluentValidation;
using Infrastructure.ImageProcessing.Interfaces;
using Infrastructure.ImageProcessing.Services;
using Infrastructure.Persistence;
using Marten;
using MediatR;

var builder = WebApplication.CreateBuilder(args);

// Add services
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new()
    {
        Title = "Lead Image Management API",
        Version = "v1",
        Description = "API for managing customer/lead images with a maximum of 10 images per lead. Images are stored as Base64 strings."
    });
});

// Add MediatR
builder.Services.AddMediatR(cfg =>
{
    cfg.RegisterServicesFromAssembly(typeof(Application.Lead.Commands.CreateLead.CreateLeadCommand).Assembly);
});

// Add FluentValidation
builder.Services.AddValidatorsFromAssembly(typeof(Application.Lead.Commands.CreateLead.CreateLeadCommandValidator).Assembly);

// Add Marten
builder.Services.AddSingleton<IDocumentStore>(provider =>
{
    var configuration = provider.GetRequiredService<IConfiguration>();
    return MartenDbContext.CreateDocumentStore(configuration);
});

builder.Services.AddScoped(provider =>
{
    var store = provider.GetRequiredService<IDocumentStore>();
    return store.LightweightSession();
});

// Register repositories
builder.Services.AddScoped<Domain.Lead.Repositories.ILeadRepository, Infrastructure.Persistence.Repositories.LeadRepository>();
builder.Services.AddScoped<Domain.Image.Repositories.ILeadImageRepository, Infrastructure.Persistence.Repositories.LeadImageRepository>();
builder.Services.AddScoped<Domain.Common.IUnitOfWork, Infrastructure.Persistence.UnitOfWork>();

// Register image processing services
builder.Services.AddSingleton<IBase64ImageProcessor, Base64ImageProcessor>();

// Add Carter
builder.Services.AddCarter();

// Add CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// Configure JSON options for large Base64 payloads
builder.Services.ConfigureHttpJsonOptions(options =>
{
    options.SerializerOptions.MaxDepth = 64;
});

// Increase request size limit for Base64 images (60MB for 10 images)
builder.WebHost.ConfigureKestrel(options =>
{
    options.Limits.MaxRequestBodySize = 62914560; // 60MB
});

var app = builder.Build();

// Configure pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");
app.MapCarter();

// Health check endpoint
app.MapGet("/health", () => Results.Ok(new
{
    Status = "Healthy",
    Timestamp = DateTime.UtcNow,
    MaxImagesPerLead = Domain.Lead.Constants.LeadConstants.MAX_IMAGES_PER_LEAD
}))
.WithName("HealthCheck")
.WithTags("Health");

app.Run();