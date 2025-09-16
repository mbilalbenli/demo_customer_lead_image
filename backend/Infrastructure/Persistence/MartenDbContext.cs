using Marten;
using Microsoft.Extensions.Configuration;
using Weasel.Core;

namespace Infrastructure.Persistence;

public static class MartenDbContext
{
    public static IDocumentStore CreateDocumentStore(IConfiguration configuration)
    {
        var connectionString = configuration.GetConnectionString(DatabaseConstants.CONNECTION_STRING_NAME)
            ?? throw new InvalidOperationException($"Connection string '{DatabaseConstants.CONNECTION_STRING_NAME}' not found.");

        var store = DocumentStore.For(options =>
        {
            options.Connection(connectionString);

            // Set schema
            options.DatabaseSchemaName = DatabaseConstants.SCHEMA_NAME;

            // Development auto-create
            // if (configuration.GetValue<bool>("Development"))
            // {
            //     options.AutoCreateSchemaObjects = Weasel.Core.AutoCreate.CreateOrUpdate;
            // }

            // Production settings
            options.CommandTimeout = DatabaseConstants.COMMAND_TIMEOUT_SECONDS;
        });

        return store;
    }
}