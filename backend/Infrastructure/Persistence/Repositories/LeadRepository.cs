using Domain.Common;
using Domain.Lead.Entities;
using Domain.Lead.Repositories;
using Domain.Lead.ValueObjects;
using Infrastructure.Persistence.Entities;
using Marten;
using Mapster;

namespace Infrastructure.Persistence.Repositories;

public class LeadRepository : ILeadRepository
{
    private readonly IDocumentSession _session;

    public LeadRepository(IDocumentSession session)
    {
        _session = session;
    }

    // Basic CRUD operations
    public async Task<Lead?> GetByIdAsync(LeadId id, CancellationToken cancellationToken = default)
    {
        var document = await _session.LoadAsync<LeadDocument>(id.Value, cancellationToken);
        return document?.Adapt<Lead>();
    }

    public async Task<Lead?> GetByIdWithImagesAsync(LeadId id, CancellationToken cancellationToken = default)
    {
        // For now, return same as GetByIdAsync since images are loaded separately
        // In a real scenario, you might want to join with image data
        var document = await _session.LoadAsync<LeadDocument>(id.Value, cancellationToken);
        return document?.Adapt<Lead>();
    }

    public async Task<IReadOnlyList<Lead>> GetAllAsync(CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadDocument>().ToListAsync(cancellationToken);
        return documents.Select(d => d.Adapt<Lead>()).ToList();
    }

    public async Task<IReadOnlyList<Lead>> GetAllWithImagesAsync(CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadDocument>().ToListAsync(cancellationToken);
        return documents.Select(d => d.Adapt<Lead>()).ToList();
    }

    public async Task<Lead> AddAsync(Lead lead, CancellationToken cancellationToken = default)
    {
        var document = lead.Adapt<LeadDocument>();
        _session.Store(document);
        await _session.SaveChangesAsync(cancellationToken);

        // Return the original lead as it already has all the data
        // The document was just for persistence
        return lead;
    }

    public async Task UpdateAsync(Lead lead, CancellationToken cancellationToken = default)
    {
        var document = lead.Adapt<LeadDocument>();
        _session.Update(document);
        await _session.SaveChangesAsync(cancellationToken);
    }

    public async Task DeleteAsync(LeadId id, CancellationToken cancellationToken = default)
    {
        _session.Delete<LeadDocument>(id.Value);
        await _session.SaveChangesAsync(cancellationToken);
    }

    // Image count validation methods - CRITICAL for enforcing 10-image limit
    public async Task<int> GetImageCountAsync(LeadId leadId, CancellationToken cancellationToken = default)
    {
        return await _session.Query<LeadImageDocument>()
            .Where(x => x.LeadId == leadId.Value)
            .CountAsync(cancellationToken);
    }

    public async Task<bool> CanAddImageAsync(LeadId leadId, CancellationToken cancellationToken = default)
    {
        var count = await GetImageCountAsync(leadId, cancellationToken);
        return count < 10;
    }

    public async Task<bool> CanAddMultipleImagesAsync(LeadId leadId, int numberOfImages, CancellationToken cancellationToken = default)
    {
        var count = await GetImageCountAsync(leadId, cancellationToken);
        return (count + numberOfImages) <= 10;
    }

    // Query methods
    public async Task<bool> ExistsAsync(LeadId id, CancellationToken cancellationToken = default)
    {
        var document = await _session.LoadAsync<LeadDocument>(id.Value, cancellationToken);
        return document != null;
    }

    public async Task<bool> EmailExistsAsync(EmailAddress email, CancellationToken cancellationToken = default)
    {
        return await _session.Query<LeadDocument>()
            .Where(x => x.Email == email.Value)
            .AnyAsync(cancellationToken);
    }

    public async Task<IReadOnlyList<Lead>> FindByEmailAsync(EmailAddress email, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadDocument>()
            .Where(x => x.Email == email.Value)
            .ToListAsync(cancellationToken);
        return documents.Select(d => d.Adapt<Lead>()).ToList();
    }

    public async Task<IReadOnlyList<Lead>> FindByPhoneAsync(PhoneNumber phone, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadDocument>()
            .Where(x => x.Phone == phone.Value)
            .ToListAsync(cancellationToken);
        return documents.Select(d => d.Adapt<Lead>()).ToList();
    }

    // Specification pattern support
    public async Task<Lead?> GetBySpecAsync(ISpecification<Lead> spec, CancellationToken cancellationToken = default)
    {
        // For now, return first lead - in real implementation, you'd apply specification
        var documents = await _session.Query<LeadDocument>().ToListAsync(cancellationToken);
        var leads = documents.Select(d => d.Adapt<Lead>());

        if (spec.Criteria != null)
        {
            var compiledCriteria = spec.Criteria.Compile();
            return leads.FirstOrDefault(compiledCriteria);
        }

        return leads.FirstOrDefault();
    }

    public async Task<IReadOnlyList<Lead>> ListAsync(ISpecification<Lead> spec, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadDocument>().ToListAsync(cancellationToken);
        var leads = documents.Select(d => d.Adapt<Lead>());

        if (spec.Criteria != null)
        {
            var compiledCriteria = spec.Criteria.Compile();
            leads = leads.Where(compiledCriteria);
        }

        return leads.ToList();
    }

    public async Task<int> CountAsync(ISpecification<Lead> spec, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadDocument>().ToListAsync(cancellationToken);
        var leads = documents.Select(d => d.Adapt<Lead>());

        if (spec.Criteria != null)
        {
            var compiledCriteria = spec.Criteria.Compile();
            return leads.Count(compiledCriteria);
        }

        return leads.Count();
    }

    // Pagination support
    public async Task<(IReadOnlyList<Lead> Items, int TotalCount)> GetPagedAsync(
        int pageNumber,
        int pageSize,
        ISpecification<Lead>? spec = null,
        CancellationToken cancellationToken = default)
    {
        var query = _session.Query<LeadDocument>();
        var totalCount = await query.CountAsync(cancellationToken);

        var documents = await query
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);

        var leads = documents.Select(d => d.Adapt<Lead>()).ToList();

        if (spec != null && spec.Criteria != null)
        {
            var compiledCriteria = spec.Criteria.Compile();
            leads = leads.Where(compiledCriteria).ToList();
        }

        return (leads, totalCount);
    }

    // Batch operations
    public async Task<IReadOnlyList<Lead>> AddRangeAsync(IEnumerable<Lead> leads, CancellationToken cancellationToken = default)
    {
        var documents = leads.Select(l => l.Adapt<LeadDocument>()).ToList();
        foreach (var document in documents)
        {
            _session.Store(document);
        }
        await _session.SaveChangesAsync(cancellationToken);
        return documents.Select(d => d.Adapt<Lead>()).ToList();
    }

    public async Task UpdateRangeAsync(IEnumerable<Lead> leads, CancellationToken cancellationToken = default)
    {
        foreach (var lead in leads)
        {
            var document = lead.Adapt<LeadDocument>();
            _session.Update(document);
        }
        await _session.SaveChangesAsync(cancellationToken);
    }

    public async Task DeleteRangeAsync(IEnumerable<LeadId> ids, CancellationToken cancellationToken = default)
    {
        foreach (var id in ids)
        {
            _session.Delete<LeadDocument>(id.Value);
        }
        await _session.SaveChangesAsync(cancellationToken);
    }

    // Image slot information
    public async Task<Dictionary<LeadId, int>> GetImageCountsForLeadsAsync(IEnumerable<LeadId> leadIds, CancellationToken cancellationToken = default)
    {
        var result = new Dictionary<LeadId, int>();
        foreach (var leadId in leadIds)
        {
            var count = await GetImageCountAsync(leadId, cancellationToken);
            result[leadId] = count;
        }
        return result;
    }

    public async Task<IReadOnlyList<(LeadId LeadId, int ImageCount, int AvailableSlots)>> GetImageSlotsInfoAsync(CancellationToken cancellationToken = default)
    {
        var leads = await GetAllAsync(cancellationToken);
        var result = new List<(LeadId LeadId, int ImageCount, int AvailableSlots)>();

        foreach (var lead in leads)
        {
            var count = await GetImageCountAsync(lead.Id, cancellationToken);
            result.Add((lead.Id, count, 10 - count));
        }

        return result;
    }
}