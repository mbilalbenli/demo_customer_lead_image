using Application.Lead.Commands.CreateLead;
using Application.Lead.Commands.DeleteLead;
using Application.Lead.Commands.UpdateLead;
using Application.Lead.Queries.GetLeadById;
using Application.Lead.Queries.GetLeadsList;
using Carter;
using MediatR;

namespace API.Modules;

public class LeadModule : ICarterModule
{
    public void AddRoutes(IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/leads")
            .WithTags("Leads")
            .WithOpenApi();

        // Create lead
        group.MapPost("", async (CreateLeadCommand command, ISender sender) =>
        {
            var result = await sender.Send(command);
            return Results.Created($"/api/leads/{result.Id}", result);
        })
        .WithName("CreateLead")
        .WithDescription("Create a new lead")
        .Produces<CreateLeadResponse>(StatusCodes.Status201Created);

        // Get lead by ID
        group.MapGet("{id:guid}", async (Guid id, ISender sender, bool includeImages = false) =>
        {
            var query = new GetLeadByIdQuery
            {
                Id = id,
                IncludeImages = includeImages
            };

            var result = await sender.Send(query);
            return result != null ? Results.Ok(result) : Results.NotFound();
        })
        .WithName("GetLeadById")
        .WithDescription("Get a lead by ID with image count information")
        .Produces<LeadDetailResponse>(StatusCodes.Status200OK)
        .Produces(StatusCodes.Status404NotFound);

        // Get all leads with pagination
        group.MapGet("", async (ISender sender, int page = 1, int pageSize = 10) =>
        {
            var query = new GetLeadsListQuery
            {
                PageNumber = page,
                PageSize = pageSize,
                IncludeImageCounts = true
            };

            var result = await sender.Send(query);
            return Results.Ok(result);
        })
        .WithName("GetLeadsList")
        .WithDescription("Get paginated list of leads with image counts")
        .Produces<LeadListResponse>(StatusCodes.Status200OK);

        // Update lead
        group.MapPut("{id:guid}", async (Guid id, UpdateLeadRequest request, ISender sender) =>
        {
            var command = new UpdateLeadCommand
            {
                Id = id,
                Name = request.Name,
                Email = request.Email,
                Phone = request.Phone,
                Status = request.Status
            };

            var result = await sender.Send(command);
            return Results.Ok(result);
        })
        .WithName("UpdateLead")
        .WithDescription("Update lead information")
        .Produces<UpdateLeadResponse>(StatusCodes.Status200OK);

        // Delete lead
        group.MapDelete("{id:guid}", async (Guid id, ISender sender) =>
        {
            var command = new DeleteLeadCommand { Id = id };
            await sender.Send(command);
            return Results.NoContent();
        })
        .WithName("DeleteLead")
        .WithDescription("Delete a lead and all associated images")
        .Produces(StatusCodes.Status204NoContent);
    }
}

// Request DTO
public record UpdateLeadRequest(
    string? Name,
    string? Email,
    string? Phone,
    Domain.Lead.Enums.LeadStatus? Status
);