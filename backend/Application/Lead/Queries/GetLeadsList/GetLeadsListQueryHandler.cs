using Domain.Common;
using Domain.Lead.Constants;
using Domain.Lead.Repositories;
using MediatR;
using System.Linq.Expressions;

namespace Application.Lead.Queries.GetLeadsList;

public sealed class GetLeadsListQueryHandler : IRequestHandler<GetLeadsListQuery, LeadListResponse>
{
    private readonly ILeadRepository _leadRepository;

    public GetLeadsListQueryHandler(ILeadRepository leadRepository)
    {
        _leadRepository = leadRepository;
    }

    public async Task<LeadListResponse> Handle(GetLeadsListQuery request, CancellationToken cancellationToken)
    {
        // Build specification
        var spec = new LeadListSpecification(request);

        // Get paged results
        var (leads, totalCount) = await _leadRepository.GetPagedAsync(
            request.PageNumber,
            request.PageSize,
            spec,
            cancellationToken);

        // Get image counts if requested
        Dictionary<Domain.Lead.ValueObjects.LeadId, int>? imageCounts = null;
        if (request.IncludeImageCounts && leads.Any())
        {
            var leadIds = leads.Select(l => l.Id).ToList();
            imageCounts = await _leadRepository.GetImageCountsForLeadsAsync(leadIds, cancellationToken);
        }

        // Map to response items
        var items = leads.Select(lead =>
        {
            var imageCount = imageCounts?.GetValueOrDefault(lead.Id) ?? 0;
            return new LeadListItem
            {
                Id = lead.Id.Value,
                Name = lead.Name.Value,
                Email = lead.Email.Value,
                Phone = lead.Phone.Value,
                Status = lead.Status,
                ImageCount = imageCount,
                AvailableImageSlots = LeadConstants.MAX_IMAGES_PER_LEAD - imageCount,
                CanAddMoreImages = imageCount < LeadConstants.MAX_IMAGES_PER_LEAD,
                CreatedAt = lead.CreatedAt,
                UpdatedAt = lead.UpdatedAt
            };
        }).ToList();

        // Calculate pagination info
        var totalPages = (int)Math.Ceiling(totalCount / (double)request.PageSize);

        return new LeadListResponse
        {
            Items = items,
            TotalCount = totalCount,
            PageNumber = request.PageNumber,
            PageSize = request.PageSize,
            TotalPages = totalPages,
            HasPreviousPage = request.PageNumber > 1,
            HasNextPage = request.PageNumber < totalPages
        };
    }

    private class LeadListSpecification : BaseSpecification<Domain.Lead.Entities.Lead>
    {
        public LeadListSpecification(GetLeadsListQuery query)
        {
            // Apply status filter
            if (query.StatusFilter.HasValue)
            {
                ApplyCriteria(lead => lead.Status == query.StatusFilter.Value);
            }

            // Apply sorting
            Expression<Func<Domain.Lead.Entities.Lead, object>> sortExpression = query.SortBy?.ToLower() switch
            {
                "name" => lead => lead.Name.Value,
                "email" => lead => lead.Email.Value,
                "status" => lead => lead.Status,
                "updatedat" => lead => lead.UpdatedAt,
                _ => lead => lead.CreatedAt
            };

            if (query.SortDescending)
            {
                ApplyOrderByDescending(sortExpression);
            }
            else
            {
                ApplyOrderBy(sortExpression);
            }
        }
    }
}