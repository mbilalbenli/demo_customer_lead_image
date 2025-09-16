using Application.Image.Commands.DeleteImage;
using Application.Image.Commands.ReplaceImage;
using Application.Image.Commands.UploadImage;
using Application.Image.Queries.GetImageCount;
using Application.Image.Queries.GetImagesByLeadId;
using Carter;
using Domain.Lead.Constants;
using MediatR;

namespace API.Modules;

public class LeadImageModule : ICarterModule
{
    public void AddRoutes(IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/leads/{leadId:guid}/images")
            .WithTags("Lead Images")
            .WithOpenApi();

        // Upload image with Base64 (enforces 10-image limit)
        group.MapPost("", async (Guid leadId, UploadImageRequest request, ISender sender) =>
        {
            try
            {
                var command = new UploadImageCommand
                {
                    LeadId = leadId,
                    Base64Image = request.Base64Image,
                    FileName = request.FileName,
                    ContentType = request.ContentType,
                    Description = request.Description
                };

                var result = await sender.Send(command);
                return Results.Ok(result);
            }
            catch (ImageLimitReachedException ex)
            {
                return Results.Conflict(new ImageLimitReachedResponse
                {
                    Error = "Image limit reached",
                    Message = ex.Message,
                    CurrentCount = ex.CurrentImageCount,
                    MaxCount = ex.MaxImageCount,
                    Suggestion = "Delete an existing image or use the replace endpoint"
                });
            }
            catch (Exception ex)
            {
                return Results.BadRequest(new { error = ex.Message });
            }
        })
        .WithName("UploadImage")
        .WithDescription("Upload a Base64-encoded image to a lead. Maximum 10 images per lead.")
        .Produces<UploadImageResponse>(StatusCodes.Status200OK)
        .Produces<ImageLimitReachedResponse>(StatusCodes.Status409Conflict)
        .Produces(StatusCodes.Status400BadRequest);

        // Get all images for a lead (returns Base64 data)
        group.MapGet("", async (Guid leadId, ISender sender, int page = 1, int pageSize = 5) =>
        {
            var query = new GetImagesByLeadIdQuery
            {
                LeadId = leadId,
                PageNumber = page,
                PageSize = Math.Min(pageSize, 5), // Max 5 to manage payload
                IncludeBase64Data = true
            };

            var result = await sender.Send(query);
            return Results.Ok(result);
        })
        .WithName("GetLeadImages")
        .WithDescription("Get all images for a lead with Base64 data. Returns max 5 images per page.")
        .Produces<LeadImagesResponse>(StatusCodes.Status200OK);

        // Delete an image
        group.MapDelete("{imageId:guid}", async (Guid leadId, Guid imageId, ISender sender) =>
        {
            var command = new DeleteImageCommand
            {
                LeadId = leadId,
                ImageId = imageId
            };

            var result = await sender.Send(command);
            return Results.Ok(result);
        })
        .WithName("DeleteImage")
        .WithDescription("Delete an image from a lead")
        .Produces<DeleteImageResponse>(StatusCodes.Status200OK);

        // Get image count and status
        group.MapGet("status", async (Guid leadId, ISender sender) =>
        {
            var query = new GetImageCountQuery { LeadId = leadId };
            var result = await sender.Send(query);
            return Results.Ok(result);
        })
        .WithName("GetImageStatus")
        .WithDescription($"Get image count and availability. Max {LeadConstants.MAX_IMAGES_PER_LEAD} images per lead.")
        .Produces<ImageCountResponse>(StatusCodes.Status200OK);

        // Replace image (clever handling of 11th image)
        group.MapPut("{imageId:guid}/replace", async (Guid leadId, Guid imageId, ReplaceImageRequest request, ISender sender) =>
        {
            var command = new ReplaceImageCommand
            {
                LeadId = leadId,
                OldImageId = imageId,
                NewBase64Image = request.Base64Image,
                NewFileName = request.FileName,
                NewContentType = request.ContentType,
                NewDescription = request.Description
            };

            var result = await sender.Send(command);
            return Results.Ok(result);
        })
        .WithName("ReplaceImage")
        .WithDescription("Replace an existing image when at the 10-image limit")
        .Produces<ReplaceImageResponse>(StatusCodes.Status200OK);
    }
}

// Request DTOs
public record UploadImageRequest(
    string Base64Image,
    string FileName,
    string? ContentType,
    string? Description
);

public record ReplaceImageRequest(
    string Base64Image,
    string FileName,
    string? ContentType,
    string? Description
);

// Response DTOs
public record ImageLimitReachedResponse(
    string Error,
    string Message,
    int CurrentCount,
    int MaxCount,
    string Suggestion
);

public record ImageStatusResponse(
    int CurrentCount,
    int MaxCount,
    int SlotsAvailable,
    bool CanAddMore
);