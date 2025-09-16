using FluentValidation;

namespace Application.Lead.Commands.DeleteLead;

public sealed class DeleteLeadCommandValidator : AbstractValidator<DeleteLeadCommand>
{
    public DeleteLeadCommandValidator()
    {
        RuleFor(x => x.Id)
            .NotEmpty().WithMessage("Lead ID is required.")
            .NotEqual(Guid.Empty).WithMessage("Lead ID cannot be empty.");
    }
}