var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

var app = builder.Build();

app.MapGet("/", () => "Hello World!");
app.MapGet("/api/hello", () => new { message = "Hello World from API!", timestamp = DateTime.UtcNow });

app.Run();