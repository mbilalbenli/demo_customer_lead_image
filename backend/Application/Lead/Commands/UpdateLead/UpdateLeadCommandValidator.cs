using Domain.Lead.Constants;
using FluentValidation;

namespace Application.Lead.Commands.UpdateLead;

public sealed class UpdateLeadCommandValidator : AbstractValidator<UpdateLeadCommand>
{
    public UpdateLeadCommandValidator()
    {
        RuleFor(x => x.Id)
            .NotEmpty().WithMessage("Lead ID is required.");

        RuleFor(x => x.Name)
            .MinimumLength(LeadConstants.MIN_NAME_LENGTH).WithMessage($"Name must be at least {LeadConstants.MIN_NAME_LENGTH} characters.")
            .MaximumLength(LeadConstants.MAX_NAME_LENGTH).WithMessage($"Name cannot exceed {LeadConstants.MAX_NAME_LENGTH} characters.")
            .When(x => !string.IsNullOrWhiteSpace(x.Name));

        RuleFor(x => x.Email)
            .MaximumLength(LeadConstants.MAX_EMAIL_LENGTH).WithMessage($"Email cannot exceed {LeadConstants.MAX_EMAIL_LENGTH} characters.")
            .EmailAddress().WithMessage("Invalid email address format.")
            .When(x => !string.IsNullOrWhiteSpace(x.Email));

        RuleFor(x => x.Phone)
            .MaximumLength(LeadConstants.MAX_PHONE_LENGTH).WithMessage($"Phone number cannot exceed {LeadConstants.MAX_PHONE_LENGTH} characters.")
            .Matches(@"^\+?[1-9]\d{1,14}$").WithMessage("Invalid phone number format. Use international format (e.g., +1234567890).")
            .When(x => !string.IsNullOrWhiteSpace(x.Phone));

        RuleFor(x => x.Status)
            .IsInEnum().WithMessage("Invalid lead status.")
            .When(x => x.Status.HasValue);

        RuleFor(x => x)
            .Must(x => !string.IsNullOrWhiteSpace(x.Name) || !string.IsNullOrWhiteSpace(x.Email) ||
                      !string.IsNullOrWhiteSpace(x.Phone) || x.Status.HasValue)
            .WithMessage("At least one field must be provided for update.");
    }
}