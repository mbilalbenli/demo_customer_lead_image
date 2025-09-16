using Domain.Common;
using Domain.Image.Entities;
using Domain.Image.Repositories;
using Domain.Image.ValueObjects;
using Domain.Lead.ValueObjects;
using Infrastructure.Persistence.Entities;
using Marten;

namespace Infrastructure.Persistence.Repositories;

public class LeadImageRepository : ILeadImageRepository
{
    private readonly IDocumentSession _session;

    public LeadImageRepository(IDocumentSession session)
    {
        _session = session;
    }

    public async Task<LeadImage?> GetByIdAsync(ImageId id, CancellationToken cancellationToken = default)
    {
        var document = await _session.LoadAsync<LeadImageDocument>(id.Value, cancellationToken);
        return document != null ? MapToDomain(document) : null;
    }

    public async Task<IReadOnlyList<LeadImage>> GetByLeadIdAsync(LeadId leadId, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>()
            .Where(x => x.LeadId == leadId.Value)
            .OrderBy(x => x.CreatedAt)
            .ToListAsync(cancellationToken);

        return documents.Select(MapToDomain).ToList();
    }

    public async Task<LeadImage> AddAsync(LeadImage image, CancellationToken cancellationToken = default)
    {
        var document = MapToDocument(image);
        _session.Store(document);
        await _session.SaveChangesAsync(cancellationToken);
        return image;
    }

    public async Task UpdateAsync(LeadImage image, CancellationToken cancellationToken = default)
    {
        var document = MapToDocument(image);
        _session.Update(document);
        await _session.SaveChangesAsync(cancellationToken);
    }

    public async Task DeleteAsync(ImageId id, CancellationToken cancellationToken = default)
    {
        _session.Delete<LeadImageDocument>(id.Value);
        await _session.SaveChangesAsync(cancellationToken);
    }

    public async Task<IReadOnlyList<LeadImage>> AddRangeAsync(IEnumerable<LeadImage> images, CancellationToken cancellationToken = default)
    {
        var imageList = images.ToList();
        foreach (var image in imageList)
        {
            var document = MapToDocument(image);
            _session.Store(document);
        }
        await _session.SaveChangesAsync(cancellationToken);
        return imageList;
    }

    public async Task DeleteRangeAsync(IEnumerable<ImageId> imageIds, CancellationToken cancellationToken = default)
    {
        foreach (var id in imageIds)
        {
            _session.Delete<LeadImageDocument>(id.Value);
        }
        await _session.SaveChangesAsync(cancellationToken);
    }

    public async Task DeleteAllByLeadIdAsync(LeadId leadId, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>()
            .Where(x => x.LeadId == leadId.Value)
            .ToListAsync(cancellationToken);

        foreach (var doc in documents)
        {
            _session.Delete<LeadImageDocument>(doc.Id);
        }
        await _session.SaveChangesAsync(cancellationToken);
    }

    public async Task<int> GetCountByLeadIdAsync(LeadId leadId, CancellationToken cancellationToken = default)
    {
        return await _session.Query<LeadImageDocument>()
            .Where(x => x.LeadId == leadId.Value)
            .CountAsync(cancellationToken);
    }

    public async Task<bool> ExistsAsync(ImageId id, CancellationToken cancellationToken = default)
    {
        return await _session.Query<LeadImageDocument>()
            .AnyAsync(x => x.Id == id.Value, cancellationToken);
    }

    public async Task<bool> BelongsToLeadAsync(ImageId imageId, LeadId leadId, CancellationToken cancellationToken = default)
    {
        return await _session.Query<LeadImageDocument>()
            .AnyAsync(x => x.Id == imageId.Value && x.LeadId == leadId.Value, cancellationToken);
    }

    public async Task<IReadOnlyList<LeadImage>> GetPagedByLeadIdAsync(
        LeadId leadId,
        int pageNumber,
        int pageSize,
        CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>()
            .Where(x => x.LeadId == leadId.Value)
            .OrderBy(x => x.CreatedAt)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);

        return documents.Select(MapToDomain).ToList();
    }

    public async Task<long> GetTotalSizeByLeadIdAsync(LeadId leadId, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>()
            .Where(x => x.LeadId == leadId.Value)
            .Select(x => x.SizeInBytes)
            .ToListAsync(cancellationToken);

        return documents.Sum();
    }

    public async Task<Dictionary<LeadId, int>> GetImageCountsAsync(IEnumerable<LeadId> leadIds, CancellationToken cancellationToken = default)
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

    public async Task<LeadImage?> GetBySpecAsync(ISpecification<LeadImage> spec, CancellationToken cancellationToken = default)
    {
        var all = await GetAllAsync(cancellationToken);
        return spec.Criteria != null
            ? all.AsQueryable().FirstOrDefault(spec.Criteria.Compile())
            : all.FirstOrDefault();
    }

    public async Task<IReadOnlyList<LeadImage>> ListAsync(ISpecification<LeadImage> spec, CancellationToken cancellationToken = default)
    {
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

    public async Task<int> CountAsync(ISpecification<LeadImage> spec, CancellationToken cancellationToken = default)
    {
        var all = await GetAllAsync(cancellationToken);
        return spec.Criteria != null
            ? all.AsQueryable().Count(spec.Criteria.Compile())
            : all.Count;
    }

    public async Task<LeadImage> ReplaceAsync(ImageId oldImageId, LeadImage newImage, CancellationToken cancellationToken = default)
    {
        // Delete old image
        await DeleteAsync(oldImageId, cancellationToken);

        // Add new image
        return await AddAsync(newImage, cancellationToken);
    }

    public async Task<IReadOnlyList<LeadImage>> GetByContentTypeAsync(string contentType, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>()
            .Where(x => x.ContentType == contentType.ToLowerInvariant())
            .ToListAsync(cancellationToken);

        return documents.Select(MapToDomain).ToList();
    }

    public async Task<IReadOnlyList<LeadImage>> GetRecentImagesAsync(int count, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>()
            .OrderByDescending(x => x.CreatedAt)
            .Take(count)
            .ToListAsync(cancellationToken);

        return documents.Select(MapToDomain).ToList();
    }

    public async Task<string?> GetBase64DataAsync(ImageId id, CancellationToken cancellationToken = default)
    {
        var document = await _session.Query<LeadImageDocument>()
            .Where(x => x.Id == id.Value)
            .Select(x => x.Base64Data)
            .FirstOrDefaultAsync(cancellationToken);

        return document;
    }

    public async Task<Dictionary<ImageId, string>> GetBase64DataBatchAsync(IEnumerable<ImageId> imageIds, CancellationToken cancellationToken = default)
    {
        var guidIds = imageIds.Select(id => id.Value).ToList();
        var documents = await _session.Query<LeadImageDocument>()
            .Where(x => guidIds.Contains(x.Id))
            .Select(x => new { x.Id, x.Base64Data })
            .ToListAsync(cancellationToken);

        return documents.ToDictionary(
            x => ImageId.From(x.Id),
            x => x.Base64Data
        );
    }

    public async Task<(int TotalImages, long TotalSizeBytes, double AverageSize)> GetStatisticsAsync(CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>()
            .Select(x => x.SizeInBytes)
            .ToListAsync(cancellationToken);

        var totalImages = documents.Count;
        var totalSize = documents.Sum(x => (long)x);
        var avgSize = totalImages > 0 ? totalSize / (double)totalImages : 0;

        return (totalImages, totalSize, avgSize);
    }

    public async Task<Dictionary<string, int>> GetContentTypeDistributionAsync(CancellationToken cancellationToken = default)
    {
        var distribution = await _session.Query<LeadImageDocument>()
            .GroupBy(x => x.ContentType)
            .Select(g => new { ContentType = g.Key, Count = g.Count() })
            .ToListAsync(cancellationToken);

        return distribution.ToDictionary(x => x.ContentType, x => x.Count);
    }

    private async Task<IReadOnlyList<LeadImage>> GetAllAsync(CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>()
            .ToListAsync(cancellationToken);

        return documents.Select(MapToDomain).ToList();
    }

    private static LeadImage MapToDomain(LeadImageDocument document)
    {
        return LeadImage.Reconstitute(
            document.Id,
            document.LeadId,
            document.Base64Data,
            document.FileName,
            document.ContentType,
            document.SizeInBytes,
            document.UploadedAt,
            document.CreatedAt,
            document.ModifiedAt,
            document.Description
        );
    }

    private static LeadImageDocument MapToDocument(LeadImage image)
    {
        return new LeadImageDocument
        {
            Id = image.Id.Value,
            LeadId = image.LeadId.Value,
            Base64Data = image.Base64Data.Value,
            FileName = image.Metadata.FileName,
            ContentType = image.Metadata.ContentType,
            SizeInBytes = image.Size.SizeInBytes,
            Description = image.Metadata.Description,
            CreatedAt = image.CreatedAt,
            UploadedAt = image.Metadata.UploadedAt,
            ModifiedAt = image.ModifiedAt
        };
    }
}