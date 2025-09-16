using Domain.Common;
using Marten;

namespace Infrastructure.Persistence;

public class UnitOfWork : IUnitOfWork
{
    private readonly IDocumentSession _session;
    private bool _disposed;

    public UnitOfWork(IDocumentSession session)
    {
        _session = session;
    }

    public bool HasActiveTransaction => _session.Connection?.State == System.Data.ConnectionState.Open;

    public async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        await _session.SaveChangesAsync(cancellationToken);
        return 1; // Marten doesn't return affected rows count
    }

    public async Task<bool> SaveEntitiesAsync(CancellationToken cancellationToken = default)
    {
        await _session.SaveChangesAsync(cancellationToken);
        return true;
    }

    public Task BeginTransactionAsync(CancellationToken cancellationToken = default)
    {
        // Marten handles transactions internally
        return Task.CompletedTask;
    }

    public async Task CommitTransactionAsync(CancellationToken cancellationToken = default)
    {
        await _session.SaveChangesAsync(cancellationToken);
    }

    public Task RollbackTransactionAsync(CancellationToken cancellationToken = default)
    {
        // Marten handles rollback automatically on dispose without SaveChanges
        return Task.CompletedTask;
    }

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool disposing)
    {
        if (!_disposed)
        {
            if (disposing)
            {
                _session?.Dispose();
            }
            _disposed = true;
        }
    }
}