using Domain.Lead.Constants;
using FluentValidation;

namespace Application.Lead.Commands.CreateLead;

public sealed class CreateLeadCommandValidator : AbstractValidator<CreateLeadCommand>
{
    public CreateLeadCommandValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Name is required.")
            .MinimumLength(LeadConstants.MIN_NAME_LENGTH).WithMessage($"Name must be at least {LeadConstants.MIN_NAME_LENGTH} characters.")
            .MaximumLength(LeadConstants.MAX_NAME_LENGTH).WithMessage($"Name cannot exceed {LeadConstants.MAX_NAME_LENGTH} characters.");

        RuleFor(x => x.Email)
            .NotEmpty().WithMessage("Email is required.")
            .MaximumLength(LeadConstants.MAX_EMAIL_LENGTH).WithMessage($"Email cannot exceed {LeadConstants.MAX_EMAIL_LENGTH} characters.")
            .EmailAddress().WithMessage("Invalid email address format.");

        RuleFor(x => x.Phone)
            .NotEmpty().WithMessage("Phone number is required.")
            .MaximumLength(LeadConstants.MAX_PHONE_LENGTH).WithMessage($"Phone number cannot exceed {LeadConstants.MAX_PHONE_LENGTH} characters.")
            .Matches(@"^\+?[1-9]\d{1,14}$").WithMessage("Invalid phone number format. Use international format (e.g., +1234567890).");

        RuleFor(x => x.Status)
            .IsInEnum().WithMessage("Invalid lead status.");

        RuleFor(x => x.Description)
            .MaximumLength(500).WithMessage("Description cannot exceed 500 characters.")
            .When(x => !string.IsNullOrWhiteSpace(x.Description));
    }
}