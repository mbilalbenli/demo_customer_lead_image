using Application.Lead.Commands.CreateLead;
using Application.Lead.Commands.DeleteLead;
using Application.Lead.Commands.UpdateLead;
using Application.Lead.Queries.GetLeadById;
using Application.Lead.Queries.GetLeadsList;
using Application.Lead.Queries.SearchLeads;
using Carter;
using MediatR;
using Microsoft.AspNetCore.Http.HttpResults;

namespace API.Modules;

public class LeadModule : ICarterModule
{
    public void AddRoutes(IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/leads")
            .WithTags("Leads");

        group.MapGet("/", GetLeadsList)
            .Produces<LeadListResponse>();

        group.MapGet("/{id:guid}", GetLeadById)
            .Produces<LeadDetailResponse>()
            .Produces(404);

        group.MapGet("/search", SearchLeads)
            .Produces<SearchLeadsResponse>();

        group.MapPost("/", CreateLead)
            .Produces<CreateLeadResponse>(201);

        group.MapPut("/{id:guid}", UpdateLead)
            .Produces<UpdateLeadResponse>()
            .Produces(404);

        group.MapDelete("/{id:guid}", DeleteLead)
            .Produces(204)
            .Produces(404);
    }

    private static async Task<Results<Ok<LeadListResponse>, BadRequest>> GetLeadsList(
        ISender sender,
        CancellationToken cancellationToken)
    {
        var query = new GetLeadsListQuery();
        var result = await sender.Send(query, cancellationToken);
        return TypedResults.Ok(result);
    }

    private static async Task<Results<Ok<LeadDetailResponse>, NotFound>> GetLeadById(
        Guid id,
        ISender sender,
        CancellationToken cancellationToken)
    {
        var query = new GetLeadByIdQuery { Id = id };
        var result = await sender.Send(query, cancellationToken);

        return result is null
            ? TypedResults.NotFound()
            : TypedResults.Ok(result);
    }

    private static async Task<Results<Ok<SearchLeadsResponse>, BadRequest>> SearchLeads(
        string? searchTerm,
        ISender sender,
        CancellationToken cancellationToken)
    {
        var query = new SearchLeadsQuery { SearchTerm = searchTerm ?? string.Empty };
        var result = await sender.Send(query, cancellationToken);
        return TypedResults.Ok(result);
    }

    private static async Task<Results<Created<CreateLeadResponse>, BadRequest<string>>> CreateLead(
        CreateLeadCommand command,
        ISender sender,
        CancellationToken cancellationToken)
    {
        var result = await sender.Send(command, cancellationToken);
        return TypedResults.Created($"/api/leads/{result.Id}", result);
    }

    private static async Task<Results<Ok<UpdateLeadResponse>, NotFound, BadRequest<string>>> UpdateLead(
        Guid id,
        UpdateLeadCommand command,
        ISender sender,
        CancellationToken cancellationToken)
    {
        // Create new command with id
        var commandWithId = command with { Id = id };
        var result = await sender.Send(commandWithId, cancellationToken);
        return TypedResults.Ok(result);
    }

    private static async Task<Results<NoContent, NotFound>> DeleteLead(
        Guid id,
        ISender sender,
        CancellationToken cancellationToken)
    {
        var command = new DeleteLeadCommand { Id = id };
        await sender.Send(command, cancellationToken);
        return TypedResults.NoContent();
    }
}