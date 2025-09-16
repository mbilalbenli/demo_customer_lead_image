using Marten;
using Marten.Events.Daemon.Resiliency;
using Marten.Services;
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

            // Configure for Base64 storage
            options.Schema.For<Entities.LeadDocument>()
                .Identity(x => x.Id)
                .Index(x => x.Email, x => x.IsUnique = true)
                .Index(x => x.Status);

            options.Schema.For<Entities.LeadImageDocument>()
                .Identity(x => x.Id)
                .Index(x => x.LeadId)
                .Index(x => x.CreatedAt)
                .ForeignKey<Entities.LeadDocument>(x => x.LeadId);

            // Configure serialization for large Base64 data
            options.Serializer<CustomJsonSerializer>();

            // Development auto-create
            if (configuration.GetValue<bool>("Development"))
            {
                options.AutoCreateSchemaObjects = AutoCreate.CreateOrUpdate;
            }

            // Production settings
            options.CommandTimeout = DatabaseConstants.COMMAND_TIMEOUT_SECONDS;
        });

        return store;
    }
}

// Custom serializer to handle large Base64 strings efficiently
public class CustomJsonSerializer : ISerializer
{
    private readonly Newtonsoft.Json.JsonSerializer _serializer;

    public CustomJsonSerializer()
    {
        _serializer = new Newtonsoft.Json.JsonSerializer
        {
            TypeNameHandling = Newtonsoft.Json.TypeNameHandling.None,
            DateTimeZoneHandling = Newtonsoft.Json.DateTimeZoneHandling.Utc,
            DateFormatHandling = Newtonsoft.Json.DateFormatHandling.IsoDateFormat
        };
    }

    public string ToJson(object document)
    {
        using var writer = new StringWriter();
        _serializer.Serialize(writer, document);
        return writer.ToString();
    }

    public T FromJson<T>(Stream stream)
    {
        using var reader = new StreamReader(stream);
        using var jsonReader = new Newtonsoft.Json.JsonTextReader(reader);
        return _serializer.Deserialize<T>(jsonReader)!;
    }

    public T FromJson<T>(DbDataReader reader, int index)
    {
        var json = reader.GetString(index);
        using var stringReader = new StringReader(json);
        using var jsonReader = new Newtonsoft.Json.JsonTextReader(stringReader);
        return _serializer.Deserialize<T>(jsonReader)!;
    }

    public object FromJson(Type type, Stream stream)
    {
        using var reader = new StreamReader(stream);
        using var jsonReader = new Newtonsoft.Json.JsonTextReader(reader);
        return _serializer.Deserialize(jsonReader, type)!;
    }

    public object FromJson(Type type, DbDataReader reader, int index)
    {
        var json = reader.GetString(index);
        using var stringReader = new StringReader(json);
        using var jsonReader = new Newtonsoft.Json.JsonTextReader(stringReader);
        return _serializer.Deserialize(jsonReader, type)!;
    }

    public string ToCleanJson(object document) => ToJson(document);

    public string ToJsonWithTypes(object document) => ToJson(document);

    public EnumStorage EnumStorage => EnumStorage.AsString;
    public Casing Casing => Casing.CamelCase;
    public ValueCasting ValueCasting => ValueCasting.Strict;
    public StreamCharBufferSize StreamCharBufferSize => StreamCharBufferSize.Default;
}