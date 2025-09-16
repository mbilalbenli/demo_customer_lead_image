using Domain.Common;
using Domain.Lead.Repositories;
using Domain.Lead.ValueObjects;
using Mapster;
using MediatR;

namespace Application.Lead.Commands.CreateLead;

public sealed class CreateLeadCommandHandler : IRequestHandler<CreateLeadCommand, CreateLeadResponse>
{
    private readonly ILeadRepository _leadRepository;
    private readonly IUnitOfWork _unitOfWork;

    public CreateLeadCommandHandler(ILeadRepository leadRepository, IUnitOfWork unitOfWork)
    {
        _leadRepository = leadRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<CreateLeadResponse> Handle(CreateLeadCommand request, CancellationToken cancellationToken)
    {
        // Check if email already exists
        var emailAddress = EmailAddress.Create(request.Email);
        if (await _leadRepository.EmailExistsAsync(emailAddress, cancellationToken))
        {
            throw new InvalidOperationException($"A lead with email '{request.Email}' already exists.");
        }

        // Create the lead using factory method
        var lead = Domain.Lead.Entities.Lead.Create(
            request.Name,
            request.Email,
            request.Phone,
            request.Status
        );

        // Add to repository
        await _leadRepository.AddAsync(lead, cancellationToken);

        // Save changes
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        // Map to response using Mapster
        var response = lead.Adapt<CreateLeadResponse>();

        // Add additional computed properties
        return response with
        {
            Id = lead.Id.Value,
            ImageCount = lead.GetImageCount(),
            AvailableImageSlots = lead.GetAvailableImageSlots()
        };
    }
}