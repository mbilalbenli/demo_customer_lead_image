using Domain.Common;
using Domain.Image.Entities;
using Domain.Image.Repositories;
using Domain.Image.ValueObjects;
using Domain.Lead.ValueObjects;
using Infrastructure.Persistence.Entities;
using Marten;
using Mapster;

namespace Infrastructure.Persistence.Repositories;

public class LeadImageRepository : ILeadImageRepository
{
    private readonly IDocumentSession _session;

    public LeadImageRepository(IDocumentSession session)
    {
        _session = session;
    }

    // Basic CRUD operations
    public async Task<LeadImage?> GetByIdAsync(ImageId id, CancellationToken cancellationToken = default)
    {
        var document = await _session.LoadAsync<LeadImageDocument>(id.Value, cancellationToken);
        return document?.Adapt<LeadImage>();
    }

    public async Task<IReadOnlyList<LeadImage>> GetByLeadIdAsync(LeadId leadId, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>()
            .Where(x => x.LeadId == leadId.Value)
            .ToListAsync(cancellationToken);

        return documents.Select(d => d.Adapt<LeadImage>()).ToList();
    }

    public async Task<LeadImage> AddAsync(LeadImage image, CancellationToken cancellationToken = default)
    {
        var document = image.Adapt<LeadImageDocument>();
        _session.Store(document);
        await _session.SaveChangesAsync(cancellationToken);
        return document.Adapt<LeadImage>();
    }

    public async Task UpdateAsync(LeadImage image, CancellationToken cancellationToken = default)
    {
        var document = image.Adapt<LeadImageDocument>();
        _session.Update(document);
        await _session.SaveChangesAsync(cancellationToken);
    }

    public async Task DeleteAsync(ImageId id, CancellationToken cancellationToken = default)
    {
        _session.Delete<LeadImageDocument>(id.Value);
        await _session.SaveChangesAsync(cancellationToken);
    }

    // Batch operations support
    public async Task<IReadOnlyList<LeadImage>> AddRangeAsync(IEnumerable<LeadImage> images, CancellationToken cancellationToken = default)
    {
        var documents = images.Select(i => i.Adapt<LeadImageDocument>()).ToList();
        foreach (var document in documents)
        {
            _session.Store(document);
        }
        await _session.SaveChangesAsync(cancellationToken);
        return documents.Select(d => d.Adapt<LeadImage>()).ToList();
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

        foreach (var document in documents)
        {
            _session.Delete(document);
        }

        await _session.SaveChangesAsync(cancellationToken);
    }

    // Count and validation methods
    public async Task<int> GetCountByLeadIdAsync(LeadId leadId, CancellationToken cancellationToken = default)
    {
        return await _session.Query<LeadImageDocument>()
            .Where(x => x.LeadId == leadId.Value)
            .CountAsync(cancellationToken);
    }

    public async Task<bool> ExistsAsync(ImageId id, CancellationToken cancellationToken = default)
    {
        var document = await _session.LoadAsync<LeadImageDocument>(id.Value, cancellationToken);
        return document != null;
    }

    public async Task<bool> BelongsToLeadAsync(ImageId imageId, LeadId leadId, CancellationToken cancellationToken = default)
    {
        var document = await _session.LoadAsync<LeadImageDocument>(imageId.Value, cancellationToken);
        return document != null && document.LeadId == leadId.Value;
    }

    // Query methods
    public async Task<IReadOnlyList<LeadImage>> GetPagedByLeadIdAsync(
        LeadId leadId,
        int pageNumber,
        int pageSize,
        CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>()
            .Where(x => x.LeadId == leadId.Value)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);

        return documents.Select(d => d.Adapt<LeadImage>()).ToList();
    }

    public async Task<long> GetTotalSizeByLeadIdAsync(LeadId leadId, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>()
            .Where(x => x.LeadId == leadId.Value)
            .ToListAsync(cancellationToken);

        return documents.Sum(d => d.SizeInBytes);
    }

    public async Task<Dictionary<LeadId, int>> GetImageCountsAsync(IEnumerable<LeadId> leadIds, CancellationToken cancellationToken = default)
    {
        var result = new Dictionary<LeadId, int>();
        foreach (var leadId in leadIds)
        {
            var count = await GetCountByLeadIdAsync(leadId, cancellationToken);
            result[leadId] = count;
        }
        return result;
    }

    // Specification pattern support
    public async Task<LeadImage?> GetBySpecAsync(ISpecification<LeadImage> spec, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>().ToListAsync(cancellationToken);
        var images = documents.Select(d => d.Adapt<LeadImage>());

        if (spec.Criteria != null)
        {
            var compiledCriteria = spec.Criteria.Compile();
            return images.FirstOrDefault(compiledCriteria);
        }

        return images.FirstOrDefault();
    }

    public async Task<IReadOnlyList<LeadImage>> ListAsync(ISpecification<LeadImage> spec, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>().ToListAsync(cancellationToken);
        var images = documents.Select(d => d.Adapt<LeadImage>());

        if (spec.Criteria != null)
        {
            var compiledCriteria = spec.Criteria.Compile();
            images = images.Where(compiledCriteria);
        }

        return images.ToList();
    }

    public async Task<int> CountAsync(ISpecification<LeadImage> spec, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>().ToListAsync(cancellationToken);
        var images = documents.Select(d => d.Adapt<LeadImage>());

        if (spec.Criteria != null)
        {
            var compiledCriteria = spec.Criteria.Compile();
            return images.Count(compiledCriteria);
        }

        return images.Count();
    }

    // Replace operation for 11th image scenario
    public async Task<LeadImage> ReplaceAsync(ImageId oldImageId, LeadImage newImage, CancellationToken cancellationToken = default)
    {
        // Delete old image
        await DeleteAsync(oldImageId, cancellationToken);
        // Add new image
        return await AddAsync(newImage, cancellationToken);
    }

    // Metadata operations
    public async Task<IReadOnlyList<LeadImage>> GetByContentTypeAsync(string contentType, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>()
            .Where(x => x.ContentType == contentType)
            .ToListAsync(cancellationToken);

        return documents.Select(d => d.Adapt<LeadImage>()).ToList();
    }

    public async Task<IReadOnlyList<LeadImage>> GetRecentImagesAsync(int count, CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>()
            .OrderByDescending(x => x.UploadedAt)
            .Take(count)
            .ToListAsync(cancellationToken);

        return documents.Select(d => d.Adapt<LeadImage>()).ToList();
    }

    // Base64 specific operations
    public async Task<string?> GetBase64DataAsync(ImageId id, CancellationToken cancellationToken = default)
    {
        var document = await _session.LoadAsync<LeadImageDocument>(id.Value, cancellationToken);
        return document?.Base64Data;
    }

    public async Task<Dictionary<ImageId, string>> GetBase64DataBatchAsync(IEnumerable<ImageId> imageIds, CancellationToken cancellationToken = default)
    {
        var result = new Dictionary<ImageId, string>();
        foreach (var id in imageIds)
        {
            var data = await GetBase64DataAsync(id, cancellationToken);
            if (data != null)
            {
                result[id] = data;
            }
        }
        return result;
    }

    // Statistics and analytics
    public async Task<(int TotalImages, long TotalSizeBytes, double AverageSize)> GetStatisticsAsync(CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>().ToListAsync(cancellationToken);
        var totalImages = documents.Count;
        var totalSizeBytes = documents.Sum(d => d.SizeInBytes);
        var averageSize = totalImages > 0 ? (double)totalSizeBytes / totalImages : 0;

        return (totalImages, totalSizeBytes, averageSize);
    }

    public async Task<Dictionary<string, int>> GetContentTypeDistributionAsync(CancellationToken cancellationToken = default)
    {
        var documents = await _session.Query<LeadImageDocument>().ToListAsync(cancellationToken);
        return documents
            .GroupBy(d => d.ContentType)
            .ToDictionary(g => g.Key, g => g.Count());
    }
}