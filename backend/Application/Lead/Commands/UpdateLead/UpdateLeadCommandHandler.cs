using Domain.Common;
using Domain.Lead.Repositories;
using Domain.Lead.ValueObjects;
using Mapster;
using MediatR;

namespace Application.Lead.Commands.UpdateLead;

public sealed class UpdateLeadCommandHandler : IRequestHandler<UpdateLeadCommand, UpdateLeadResponse>
{
    private readonly ILeadRepository _leadRepository;
    private readonly IUnitOfWork _unitOfWork;

    public UpdateLeadCommandHandler(ILeadRepository leadRepository, IUnitOfWork unitOfWork)
    {
        _leadRepository = leadRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<UpdateLeadResponse> Handle(UpdateLeadCommand request, CancellationToken cancellationToken)
    {
        // Retrieve the lead with images
        var leadId = LeadId.From(request.Id);
        var lead = await _leadRepository.GetByIdWithImagesAsync(leadId, cancellationToken);

        if (lead == null)
        {
            throw new KeyNotFoundException($"Lead with ID '{request.Id}' not found.");
        }

        // Check if email is being changed and if it already exists
        if (!string.IsNullOrWhiteSpace(request.Email) &&
            !lead.Email.Value.Equals(request.Email, StringComparison.OrdinalIgnoreCase))
        {
            var newEmail = EmailAddress.Create(request.Email);
            if (await _leadRepository.EmailExistsAsync(newEmail, cancellationToken))
            {
                throw new InvalidOperationException($"A lead with email '{request.Email}' already exists.");
            }
        }

        // Update the lead's contact information
        lead.UpdateContactInfo(request.Name, request.Email, request.Phone);

        // Update status if provided
        if (request.Status.HasValue)
        {
            lead.UpdateStatus(request.Status.Value);
        }

        // Update in repository
        await _leadRepository.UpdateAsync(lead, cancellationToken);

        // Save changes
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        // Map to response using Mapster
        var response = lead.Adapt<UpdateLeadResponse>();

        // Add additional computed properties
        return response with
        {
            Id = lead.Id.Value,
            ImageCount = lead.GetImageCount(),
            AvailableImageSlots = lead.GetAvailableImageSlots()
        };
    }
}