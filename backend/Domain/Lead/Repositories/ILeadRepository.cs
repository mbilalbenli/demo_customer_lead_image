using Domain.Common;
using Domain.Lead.Entities;
using Domain.Lead.ValueObjects;

namespace Domain.Lead.Repositories;

public interface ILeadRepository
{
    // Basic CRUD operations
    Task<Entities.Lead?> GetByIdAsync(LeadId id, CancellationToken cancellationToken = default);
    Task<Entities.Lead?> GetByIdWithImagesAsync(LeadId id, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Entities.Lead>> GetAllAsync(CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Entities.Lead>> GetAllWithImagesAsync(CancellationToken cancellationToken = default);
    Task<Entities.Lead> AddAsync(Entities.Lead lead, CancellationToken cancellationToken = default);
    Task UpdateAsync(Entities.Lead lead, CancellationToken cancellationToken = default);
    Task DeleteAsync(LeadId id, CancellationToken cancellationToken = default);

    // Image count validation methods - CRITICAL for enforcing 10-image limit
    Task<int> GetImageCountAsync(LeadId leadId, CancellationToken cancellationToken = default);
    Task<bool> CanAddImageAsync(LeadId leadId, CancellationToken cancellationToken = default);
    Task<bool> CanAddMultipleImagesAsync(LeadId leadId, int numberOfImages, CancellationToken cancellationToken = default);

    // Query methods
    Task<bool> ExistsAsync(LeadId id, CancellationToken cancellationToken = default);
    Task<bool> EmailExistsAsync(EmailAddress email, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Entities.Lead>> FindByEmailAsync(EmailAddress email, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Entities.Lead>> FindByPhoneAsync(PhoneNumber phone, CancellationToken cancellationToken = default);

    // Specification pattern support
    Task<Entities.Lead?> GetBySpecAsync(ISpecification<Entities.Lead> spec, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Entities.Lead>> ListAsync(ISpecification<Entities.Lead> spec, CancellationToken cancellationToken = default);
    Task<int> CountAsync(ISpecification<Entities.Lead> spec, CancellationToken cancellationToken = default);

    // Pagination support
    Task<(IReadOnlyList<Entities.Lead> Items, int TotalCount)> GetPagedAsync(
        int pageNumber,
        int pageSize,
        ISpecification<Entities.Lead>? spec = null,
        CancellationToken cancellationToken = default);

    // Batch operations
    Task<IReadOnlyList<Entities.Lead>> AddRangeAsync(IEnumerable<Entities.Lead> leads, CancellationToken cancellationToken = default);
    Task UpdateRangeAsync(IEnumerable<Entities.Lead> leads, CancellationToken cancellationToken = default);
    Task DeleteRangeAsync(IEnumerable<LeadId> ids, CancellationToken cancellationToken = default);

    // Image slot information
    Task<Dictionary<LeadId, int>> GetImageCountsForLeadsAsync(IEnumerable<LeadId> leadIds, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<(LeadId LeadId, int ImageCount, int AvailableSlots)>> GetImageSlotsInfoAsync(CancellationToken cancellationToken = default);
}