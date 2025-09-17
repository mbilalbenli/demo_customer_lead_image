using Domain.Lead.Entities;
using Domain.Lead.ValueObjects;
using Domain.Lead.Enums;
using Domain.Image.Entities;
using Domain.Image.ValueObjects;
using Infrastructure.Persistence.Entities;
using Mapster;

namespace Infrastructure.Persistence;

public static class MappingConfiguration
{
    public static void Configure()
    {
        // Configure mapping from LeadDocument to Lead (domain entity)
        TypeAdapterConfig.GlobalSettings
            .ForType<LeadDocument, Lead>()
            .ConstructUsing(src => Lead.Reconstitute(
                src.Id,
                src.Name,
                src.Email,
                src.Phone,
                src.Status,
                src.CreatedAt,
                src.UpdatedAt,
                null // images loaded separately
            ))
            .IgnoreNonMapped(true);

        // Configure mapping from Lead to LeadDocument
        TypeAdapterConfig.GlobalSettings
            .ForType<Lead, LeadDocument>()
            .Map(dest => dest.Id, src => src.Id.Value)
            .Map(dest => dest.Name, src => src.Name.Value)
            .Map(dest => dest.Email, src => src.Email.Value)
            .Map(dest => dest.Phone, src => src.Phone.Value)
            .Map(dest => dest.Status, src => src.Status)
            .Map(dest => dest.CreatedAt, src => src.CreatedAt)
            .Map(dest => dest.UpdatedAt, src => src.UpdatedAt)
            .Map(dest => dest.ImageCount, src => src.Images.Count);

        // Configure mapping from LeadImageDocument to LeadImage (domain entity)
        TypeAdapterConfig.GlobalSettings
            .ForType<LeadImageDocument, LeadImage>()
            .ConstructUsing(src => LeadImage.Reconstitute(
                src.Id,
                src.LeadId,
                src.Base64Data,
                src.FileName,
                src.ContentType,
                src.SizeInBytes,
                src.UploadedAt,
                src.CreatedAt,
                src.ModifiedAt,
                src.Description
            ))
            .IgnoreNonMapped(true);

        // Configure mapping from LeadImage to LeadImageDocument
        TypeAdapterConfig.GlobalSettings
            .ForType<LeadImage, LeadImageDocument>()
            .Map(dest => dest.Id, src => src.Id.Value)
            .Map(dest => dest.LeadId, src => src.LeadId.Value)
            .Map(dest => dest.Base64Data, src => src.Base64Data.Value)
            .Map(dest => dest.FileName, src => src.Metadata.FileName)
            .Map(dest => dest.ContentType, src => src.Metadata.ContentType)
            .Map(dest => dest.SizeInBytes, src => src.Size.SizeInBytes)
            .Map(dest => dest.UploadedAt, src => src.Metadata.UploadedAt)
            .Map(dest => dest.Description, src => src.Metadata.Description)
            .Map(dest => dest.CreatedAt, src => src.CreatedAt)
            .Map(dest => dest.ModifiedAt, src => src.ModifiedAt);
    }
}