using Domain.Common;
using Domain.Image.Entities;
using Domain.Lead.Constants;
using Domain.Lead.Repositories;
using Domain.Lead.ValueObjects;
using Infrastructure.Persistence.Entities;
using Marten;
using Marten.Linq;

namespace Infrastructure.Persistence.Repositories;

public class LeadRepository : ILeadRepository
{
    private readonly IDocumentSession _session;

    public LeadRepository(IDocumentSession session)
    {
        _session = session;
    }

    public async Task<Domain.Lead.Entities.Lead?> GetByIdAsync(LeadId id, CancellationToken cancellationToken = default)
    {
        var document = await _session.LoadAsync<LeadDocument>(id.Value, cancellationToken);
        return document != null ? MapToDomain(document) : null;
    }

    public async Task<Domain.Lead.Entities.Lead?> GetByIdWithImagesAsync(LeadId id, CancellationToken cancellationToken = default)
    {
        var document = await _session.LoadAsync<LeadDocument>(id.Value, cancellationToken);
        if (document == null) return null;

        var images = await _session.Query<LeadImageDocument>()
            .Where(x => x.LeadId == id.Value)
            .ToListAsync(cancellationToken);

        return MapToDomainWithImages(document, images);
    }

    public async Task<IReadOnlyList<Domain.Lead.Entities.Lead>> GetAllAsync(CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadDocument>()
            .ToListAsync(cancellationToken);

        return documents.Select(MapToDomain).ToList();
    }

    public async Task<IReadOnlyList<Domain.Lead.Entities.Lead>> GetAllWithImagesAsync(CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadDocument>()
            .ToListAsync(cancellationToken);

        var leadIds = documents.Select(d => d.Id).ToList();
        var allImages = await _session.Query<LeadImageDocument>()
            .Where(x => leadIds.Contains(x.LeadId))
            .ToListAsync(cancellationToken);

        var imagesByLead = allImages.GroupBy(x => x.LeadId).ToDictionary(g => g.Key, g => g.ToList());

        return documents.Select(doc =>
        {
            var images = imagesByLead.GetValueOrDefault(doc.Id) ?? new List<LeadImageDocument>();
            return MapToDomainWithImages(doc, images);
        }).ToList();
    }

    public async Task<Domain.Lead.Entities.Lead> AddAsync(Domain.Lead.Entities.Lead lead, CancellationToken cancellationToken = default)
    {
        var document = MapToDocument(lead);
        _session.Store(document);
        await _session.SaveChangesAsync(cancellationToken);
        return lead;
    }

    public async Task UpdateAsync(Domain.Lead.Entities.Lead lead, CancellationToken cancellationToken = default)
    {
        var document = MapToDocument(lead);
        document.ImageCount = lead.GetImageCount(); // Update denormalized count
        _session.Update(document);
        await _session.SaveChangesAsync(cancellationToken);
    }

    public async Task DeleteAsync(LeadId id, CancellationToken cancellationToken = default)
    {
        _session.Delete<LeadDocument>(id.Value);
        await _session.SaveChangesAsync(cancellationToken);
    }

    // CRITICAL: Image count validation methods for enforcing 10-image limit
    public async Task<int> GetImageCountAsync(LeadId leadId, CancellationToken cancellationToken = default)
    {
        return await _session.Query<LeadImageDocument>()
            .Where(x => x.LeadId == leadId.Value)
            .CountAsync(cancellationToken);
    }

    public async Task<bool> CanAddImageAsync(LeadId leadId, CancellationToken cancellationToken = default)
    {
        var count = await GetImageCountAsync(leadId, cancellationToken);
        return count < LeadConstants.MAX_IMAGES_PER_LEAD;
    }

    public async Task<bool> CanAddMultipleImagesAsync(LeadId leadId, int numberOfImages, CancellationToken cancellationToken = default)
    {
        var currentCount = await GetImageCountAsync(leadId, cancellationToken);
        return (currentCount + numberOfImages) <= LeadConstants.MAX_IMAGES_PER_LEAD;
    }

    public async Task<bool> ExistsAsync(LeadId id, CancellationToken cancellationToken = default)
    {
        return await _session.Query<LeadDocument>()
            .AnyAsync(x => x.Id == id.Value, cancellationToken);
    }

    public async Task<bool> EmailExistsAsync(EmailAddress email, CancellationToken cancellationToken = default)
    {
        return await _session.Query<LeadDocument>()
            .AnyAsync(x => x.Email == email.Value, cancellationToken);
    }

    public async Task<IReadOnlyList<Domain.Lead.Entities.Lead>> FindByEmailAsync(EmailAddress email, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadDocument>()
            .Where(x => x.Email == email.Value)
            .ToListAsync(cancellationToken);

        return documents.Select(MapToDomain).ToList();
    }

    public async Task<IReadOnlyList<Domain.Lead.Entities.Lead>> FindByPhoneAsync(PhoneNumber phone, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadDocument>()
            .Where(x => x.Phone == phone.Value)
            .ToListAsync(cancellationToken);

        return documents.Select(MapToDomain).ToList();
    }

    public async Task<Domain.Lead.Entities.Lead?> GetBySpecAsync(ISpecification<Domain.Lead.Entities.Lead> spec, CancellationToken cancellationToken = default)
    {
        // For simplicity, load all and filter in memory
        // In production, translate specification to Marten query
        var all = await GetAllAsync(cancellationToken);
        return spec.Criteria != null
            ? all.AsQueryable().FirstOrDefault(spec.Criteria.Compile())
            : all.FirstOrDefault();
    }

    public async Task<IReadOnlyList<Domain.Lead.Entities.Lead>> ListAsync(ISpecification<Domain.Lead.Entities.Lead> spec, CancellationToken cancellationToken = default)
    {
        // For simplicity, load all and filter in memory
        var all = await GetAllAsync(cancellationToken);
        var query = all.AsQueryable();

        if (spec.Criteria != null)
            query = query.Where(spec.Criteria.Compile());

        if (spec.OrderBy != null)
            query = query.OrderBy(spec.OrderBy.Compile());
        else if (spec.OrderByDescending != null)
            query = query.OrderByDescending(spec.OrderByDescending.Compile());

        if (spec.IsPagingEnabled)
            query = query.Skip(spec.Skip ?? 0).Take(spec.Take ?? 10);

        return query.ToList();
    }

    public async Task<int> CountAsync(ISpecification<Domain.Lead.Entities.Lead> spec, CancellationToken cancellationToken = default)
    {
        var all = await GetAllAsync(cancellationToken);
        return spec.Criteria != null
            ? all.AsQueryable().Count(spec.Criteria.Compile())
            : all.Count;
    }

    public async Task<(IReadOnlyList<Domain.Lead.Entities.Lead> Items, int TotalCount)> GetPagedAsync(
        int pageNumber,
        int pageSize,
        ISpecification<Domain.Lead.Entities.Lead>? spec = null,
        CancellationToken cancellationToken = default)
    {
        var query = _session.Query<LeadDocument>();

        var totalCount = await query.CountAsync(cancellationToken);

        var documents = await query
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);

        var items = documents.Select(MapToDomain).ToList();

        return (items, totalCount);
    }

    public async Task<IReadOnlyList<Domain.Lead.Entities.Lead>> AddRangeAsync(IEnumerable<Domain.Lead.Entities.Lead> leads, CancellationToken cancellationToken = default)
    {
        var leadList = leads.ToList();
        foreach (var lead in leadList)
        {
            var document = MapToDocument(lead);
            _session.Store(document);
        }
        await _session.SaveChangesAsync(cancellationToken);
        return leadList;
    }

    public async Task UpdateRangeAsync(IEnumerable<Domain.Lead.Entities.Lead> leads, CancellationToken cancellationToken = default)
    {
        foreach (var lead in leads)
        {
            var document = MapToDocument(lead);
            document.ImageCount = lead.GetImageCount();
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

    public async Task<Dictionary<LeadId, int>> GetImageCountsForLeadsAsync(IEnumerable<LeadId> leadIds, CancellationToken cancellationToken = default)
    {
        var guidIds = leadIds.Select(id => id.Value).ToList();
        var counts = await _session.Query<LeadImageDocument>()
            .Where(x => guidIds.Contains(x.LeadId))
            .GroupBy(x => x.LeadId)
            .Select(g => new { LeadId = g.Key, Count = g.Count() })
            .ToListAsync(cancellationToken);

        return counts.ToDictionary(
            x => LeadId.From(x.LeadId),
            x => x.Count
        );
    }

    public async Task<IReadOnlyList<(LeadId LeadId, int ImageCount, int AvailableSlots)>> GetImageSlotsInfoAsync(CancellationToken cancellationToken = default)
    {
        var allLeads = await _session.Query<LeadDocument>().ToListAsync(cancellationToken);
        var leadIds = allLeads.Select(l => l.Id).ToList();

        var imageCounts = await _session.Query<LeadImageDocument>()
            .Where(x => leadIds.Contains(x.LeadId))
            .GroupBy(x => x.LeadId)
            .Select(g => new { LeadId = g.Key, Count = g.Count() })
            .ToListAsync(cancellationToken);

        var countDict = imageCounts.ToDictionary(x => x.LeadId, x => x.Count);

        return allLeads.Select(lead =>
        {
            var count = countDict.GetValueOrDefault(lead.Id, 0);
            return (
                LeadId.From(lead.Id),
                count,
                LeadConstants.MAX_IMAGES_PER_LEAD - count
            );
        }).ToList();
    }

    // Mapping methods
    private static Domain.Lead.Entities.Lead MapToDomain(LeadDocument document)
    {
        return Domain.Lead.Entities.Lead.Reconstitute(
            document.Id,
            document.Name,
            document.Email,
            document.Phone,
            document.Status,
            document.CreatedAt,
            document.UpdatedAt
        );
    }

    private static Domain.Lead.Entities.Lead MapToDomainWithImages(LeadDocument document, List<LeadImageDocument> imageDocuments)
    {
        var images = imageDocuments.Select(img => LeadImage.Reconstitute(
            img.Id,
            img.LeadId,
            img.Base64Data,
            img.FileName,
            img.ContentType,
            img.SizeInBytes,
            img.UploadedAt,
            img.CreatedAt,
            img.ModifiedAt,
            img.Description
        )).ToList();

        return Domain.Lead.Entities.Lead.Reconstitute(
            document.Id,
            document.Name,
            document.Email,
            document.Phone,
            document.Status,
            document.CreatedAt,
            document.UpdatedAt,
            images
        );
    }

    private static LeadDocument MapToDocument(Domain.Lead.Entities.Lead lead)
    {
        return new LeadDocument
        {
            Id = lead.Id.Value,
            Name = lead.Name.Value,
            Email = lead.Email.Value,
            Phone = lead.Phone.Value,
            Status = lead.Status,
            CreatedAt = lead.CreatedAt,
            UpdatedAt = lead.UpdatedAt,
            ImageCount = lead.GetImageCount()
        };
    }
}