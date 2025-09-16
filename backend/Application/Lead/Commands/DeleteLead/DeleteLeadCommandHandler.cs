using Domain.Common;
using Domain.Image.Repositories;
using Domain.Lead.Repositories;
using Domain.Lead.ValueObjects;
using MediatR;

namespace Application.Lead.Commands.DeleteLead;

public sealed class DeleteLeadCommandHandler : IRequestHandler<DeleteLeadCommand, Unit>
{
    private readonly ILeadRepository _leadRepository;
    private readonly ILeadImageRepository _imageRepository;
    private readonly IUnitOfWork _unitOfWork;

    public DeleteLeadCommandHandler(
        ILeadRepository leadRepository,
        ILeadImageRepository imageRepository,
        IUnitOfWork unitOfWork)
    {
        _leadRepository = leadRepository;
        _imageRepository = imageRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<Unit> Handle(DeleteLeadCommand request, CancellationToken cancellationToken)
    {
        var leadId = LeadId.From(request.Id);

        // Check if lead exists
        if (!await _leadRepository.ExistsAsync(leadId, cancellationToken))
        {
            throw new KeyNotFoundException($"Lead with ID '{request.Id}' not found.");
        }

        // Start transaction for atomic deletion
        await _unitOfWork.BeginTransactionAsync(cancellationToken);

        try
        {
            // Delete all associated images first (cascade delete)
            await _imageRepository.DeleteAllByLeadIdAsync(leadId, cancellationToken);

            // Delete the lead
            await _leadRepository.DeleteAsync(leadId, cancellationToken);

            // Commit transaction
            await _unitOfWork.CommitTransactionAsync(cancellationToken);
        }
        catch
        {
            // Rollback on any error
            await _unitOfWork.RollbackTransactionAsync(cancellationToken);
            throw;
        }

        return Unit.Value;
    }
}