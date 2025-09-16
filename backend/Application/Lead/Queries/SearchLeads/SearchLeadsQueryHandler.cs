using Domain.Common;
using Domain.Lead.Constants;
using Domain.Lead.Repositories;
using MediatR;
using System.Linq.Expressions;

namespace Application.Lead.Queries.SearchLeads;

public sealed class SearchLeadsQueryHandler : IRequestHandler<SearchLeadsQuery, SearchLeadsResponse>
{
    private readonly ILeadRepository _leadRepository;

    public SearchLeadsQueryHandler(ILeadRepository leadRepository)
    {
        _leadRepository = leadRepository;
    }

    public async Task<SearchLeadsResponse> Handle(SearchLeadsQuery request, CancellationToken cancellationToken)
    {
        // Get all leads for initial filtering
        var allLeads = await _leadRepository.GetAllWithImagesAsync(cancellationToken);

        // Apply search filters
        var query = allLeads.AsQueryable();

        // Text search
        if (!string.IsNullOrWhiteSpace(request.SearchTerm))
        {
            var searchTerm = request.SearchTerm.ToLower();
            query = query.Where(lead =>
                (request.SearchByName && lead.Name.Value.ToLower().Contains(searchTerm)) ||
                (request.SearchByEmail && lead.Email.Value.ToLower().Contains(searchTerm)) ||
                (request.SearchByPhone && lead.Phone.Value.Contains(searchTerm))
            );
        }

        // Image count filters
        if (request.MinImageCount.HasValue)
        {
            query = query.Where(lead => lead.Images.Count >= request.MinImageCount.Value);
        }

        if (request.MaxImageCount.HasValue)
        {
            query = query.Where(lead => lead.Images.Count <= request.MaxImageCount.Value);
        }

        if (request.OnlyLeadsWithImages)
        {
            query = query.Where(lead => lead.Images.Any());
        }

        if (request.OnlyLeadsAtImageLimit)
        {
            query = query.Where(lead => lead.Images.Count == LeadConstants.MAX_IMAGES_PER_LEAD);
        }

        // Get total count before pagination
        var totalResults = query.Count();

        // Apply pagination
        var pagedResults = query
            .OrderByDescending(l => l.CreatedAt)
            .Skip((request.PageNumber - 1) * request.PageSize)
            .Take(request.PageSize)
            .ToList();

        // Calculate relevance scores (simple scoring based on match quality)
        var results = pagedResults.Select(lead =>
        {
            double? relevanceScore = null;
            if (!string.IsNullOrWhiteSpace(request.SearchTerm))
            {
                var searchTerm = request.SearchTerm.ToLower();
                var score = 0.0;

                // Exact matches get higher scores
                if (lead.Name.Value.ToLower() == searchTerm) score += 3.0;
                else if (lead.Name.Value.ToLower().Contains(searchTerm)) score += 1.5;

                if (lead.Email.Value.ToLower() == searchTerm) score += 2.0;
                else if (lead.Email.Value.ToLower().Contains(searchTerm)) score += 1.0;

                if (lead.Phone.Value.Contains(searchTerm)) score += 1.0;

                relevanceScore = score;
            }

            return new SearchLeadItem
            {
                Id = lead.Id.Value,
                Name = lead.Name.Value,
                Email = lead.Email.Value,
                Phone = lead.Phone.Value,
                Status = lead.Status,
                ImageCount = lead.GetImageCount(),
                AvailableImageSlots = lead.GetAvailableImageSlots(),
                IsAtImageLimit = !lead.CanAddImage(),
                CreatedAt = lead.CreatedAt,
                RelevanceScore = relevanceScore
            };
        })
        .OrderByDescending(r => r.RelevanceScore ?? 0)
        .ThenByDescending(r => r.CreatedAt)
        .ToList();

        // Calculate pagination info
        var totalPages = (int)Math.Ceiling(totalResults / (double)request.PageSize);

        return new SearchLeadsResponse
        {
            Results = results,
            TotalResults = totalResults,
            SearchTerm = request.SearchTerm,
            PageNumber = request.PageNumber,
            PageSize = request.PageSize,
            TotalPages = totalPages
        };
    }
}