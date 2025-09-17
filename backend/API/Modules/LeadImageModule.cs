using Application.Image.Commands.DeleteImage;
using Application.Image.Commands.ReplaceImage;
using Application.Image.Commands.UploadImage;
using Application.Image.Commands.BatchUploadImages;
using Application.Image.Commands.ValidateImage;
using Application.Image.Queries.GetImageCount;
using Application.Image.Queries.GetImagesByLeadId;
using Carter;
using MediatR;
using Microsoft.AspNetCore.Http.HttpResults;

namespace API.Modules;

public class LeadImageModule : ICarterModule
{
    public void AddRoutes(IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/leads/{leadId:guid}/images")
            .WithTags("Lead Images");

        group.MapGet("/", GetImagesByLeadId)
            .Produces<LeadImagesResponse>();

        group.MapGet("/count", GetImageCount)
            .Produces<ImageCountResponse>();

        group.MapPost("/", UploadImage)
            .Produces<UploadImageResponse>(201)
            .Produces(400);

        // Batch upload
        group.MapPost("/batch", BatchUploadImages)
            .Produces<BatchUploadImagesResponse>(201)
            .Produces(400);

        // Validate image pre-upload
        group.MapPost("/validate", ValidateImage)
            .Produces<ValidateImageResponse>()
            .Produces(400);

        group.MapPut("/{imageId:guid}", ReplaceImage)
            .Produces<ReplaceImageResponse>()
            .Produces(404)
            .Produces(400);

        group.MapDelete("/{imageId:guid}", DeleteImage)
            .Produces<DeleteImageResponse>()
            .Produces(404)
            .Produces(400);
    }

    private static async Task<Results<Ok<LeadImagesResponse>, NotFound>> GetImagesByLeadId(
        Guid leadId,
        ISender sender,
        CancellationToken cancellationToken)
    {
        var query = new GetImagesByLeadIdQuery { LeadId = leadId };
        var result = await sender.Send(query, cancellationToken);
        return TypedResults.Ok(result);
    }

    private static async Task<Results<Ok<ImageCountResponse>, NotFound>> GetImageCount(
        Guid leadId,
        ISender sender,
        CancellationToken cancellationToken)
    {
        var query = new GetImageCountQuery { LeadId = leadId };
        var result = await sender.Send(query, cancellationToken);
        return TypedResults.Ok(result);
    }

    private static async Task<Results<Created<UploadImageResponse>, BadRequest<string>>> UploadImage(
        Guid leadId,
        UploadImageCommand command,
        ISender sender,
        CancellationToken cancellationToken)
    {
        // Create new command with leadId
        var commandWithLeadId = command with { LeadId = leadId };
        var result = await sender.Send(commandWithLeadId, cancellationToken);
        return TypedResults.Created($"/api/leads/{leadId}/images/{result.ImageId}", result);
    }

    private static async Task<Results<Created<BatchUploadImagesResponse>, BadRequest<string>>> BatchUploadImages(
        Guid leadId,
        BatchUploadImagesCommand command,
        ISender sender,
        CancellationToken cancellationToken)
    {
        var withLead = command with { LeadId = leadId };
        var result = await sender.Send(withLead, cancellationToken);
        return TypedResults.Created($"/api/leads/{leadId}/images", result);
    }

    private static async Task<Results<Ok<ValidateImageResponse>, BadRequest<string>>> ValidateImage(
        Guid leadId,
        ValidateImageCommand command,
        ISender sender,
        CancellationToken cancellationToken)
    {
        // leadId unused but kept for consistent route shape
        var result = await sender.Send(command, cancellationToken);
        return TypedResults.Ok(result);
    }

    private static async Task<Results<Ok<ReplaceImageResponse>, NotFound, BadRequest<string>>> ReplaceImage(
        Guid leadId,
        Guid imageId,
        ReplaceImageCommand command,
        ISender sender,
        CancellationToken cancellationToken)
    {
        // Create new command with leadId and imageId
        var commandWithIds = command with { LeadId = leadId, OldImageId = imageId };
        var result = await sender.Send(commandWithIds, cancellationToken);
        return TypedResults.Ok(result);
    }

    private static async Task<Results<Ok<DeleteImageResponse>, NotFound<string>, BadRequest<string>>> DeleteImage(
        Guid leadId,
        Guid imageId,
        ISender sender,
        CancellationToken cancellationToken)
    {
        try
        {
            var command = new DeleteImageCommand { LeadId = leadId, ImageId = imageId };
            var result = await sender.Send(command, cancellationToken);
            return TypedResults.Ok(result);
        }
        catch (KeyNotFoundException ex)
        {
            return TypedResults.NotFound(ex.Message);
        }
        catch (InvalidOperationException ex)
        {
            // For delete, treat invalid state (e.g., image not belonging to lead)
            // as NotFound to avoid leaking existence and to keep DELETE idempotent
            return TypedResults.NotFound(ex.Message);
        }
    }
}
