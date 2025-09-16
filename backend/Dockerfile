FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copy solution and all project files
COPY *.sln ./
COPY backend.csproj ./
COPY API/API.csproj ./API/
COPY Application/Application.csproj ./Application/
COPY Domain/Domain.csproj ./Domain/
COPY Infrastructure/Infrastructure.csproj ./Infrastructure/

# Restore dependencies
RUN dotnet restore backend.csproj

# Copy source code
COPY . ./

# Build and publish
RUN dotnet publish backend.csproj -c Release -o out --no-restore -nowarn:CS0436

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/out .
EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Development
ENTRYPOINT ["dotnet", "backend.dll"]