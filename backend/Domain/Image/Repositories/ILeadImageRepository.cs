using Domain.Common;
using Domain.Image.Entities;
using Domain.Image.ValueObjects;
using Domain.Lead.ValueObjects;

namespace Domain.Image.Repositories;

public interface ILeadImageRepository
{
    // Basic CRUD operations
    Task<LeadImage?> GetByIdAsync(ImageId id, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<LeadImage>> GetByLeadIdAsync(LeadId leadId, CancellationToken cancellationToken = default);
    Task<LeadImage> AddAsync(LeadImage image, CancellationToken cancellationToken = default);
    Task UpdateAsync(LeadImage image, CancellationToken cancellationToken = default);
    Task DeleteAsync(ImageId id, CancellationToken cancellationToken = default);

    // Batch operations support
    Task<IReadOnlyList<LeadImage>> AddRangeAsync(IEnumerable<LeadImage> images, CancellationToken cancellationToken = default);
    Task DeleteRangeAsync(IEnumerable<ImageId> imageIds, CancellationToken cancellationToken = default);
    Task DeleteAllByLeadIdAsync(LeadId leadId, CancellationToken cancellationToken = default);

    // Count and validation methods
    Task<int> GetCountByLeadIdAsync(LeadId leadId, CancellationToken cancellationToken = default);
    Task<bool> ExistsAsync(ImageId id, CancellationToken cancellationToken = default);
    Task<bool> BelongsToLeadAsync(ImageId imageId, LeadId leadId, CancellationToken cancellationToken = default);

    // Query methods
    Task<IReadOnlyList<LeadImage>> GetPagedByLeadIdAsync(
        LeadId leadId,
        int pageNumber,
        int pageSize,
        CancellationToken cancellationToken = default);

    Task<long> GetTotalSizeByLeadIdAsync(LeadId leadId, CancellationToken cancellationToken = default);
    Task<Dictionary<LeadId, int>> GetImageCountsAsync(IEnumerable<LeadId> leadIds, CancellationToken cancellationToken = default);

    // Specification pattern support
    Task<LeadImage?> GetBySpecAsync(ISpecification<LeadImage> spec, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<LeadImage>> ListAsync(ISpecification<LeadImage> spec, CancellationToken cancellationToken = default);
    Task<int> CountAsync(ISpecification<LeadImage> spec, CancellationToken cancellationToken = default);

    // Replace operation for 11th image scenario
    Task<LeadImage> ReplaceAsync(ImageId oldImageId, LeadImage newImage, CancellationToken cancellationToken = default);

    // Metadata operations
    Task<IReadOnlyList<LeadImage>> GetByContentTypeAsync(string contentType, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<LeadImage>> GetRecentImagesAsync(int count, CancellationToken cancellationToken = default);

    // Base64 specific operations
    Task<string?> GetBase64DataAsync(ImageId id, CancellationToken cancellationToken = default);
    Task<Dictionary<ImageId, string>> GetBase64DataBatchAsync(IEnumerable<ImageId> imageIds, CancellationToken cancellationToken = default);

    // Statistics and analytics
    Task<(int TotalImages, long TotalSizeBytes, double AverageSize)> GetStatisticsAsync(CancellationToken cancellationToken = default);
    Task<Dictionary<string, int>> GetContentTypeDistributionAsync(CancellationToken cancellationToken = default);
}