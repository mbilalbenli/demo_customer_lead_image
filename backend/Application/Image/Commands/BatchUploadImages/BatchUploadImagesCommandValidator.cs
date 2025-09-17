using Domain.Image.Constants;
using FluentValidation;

namespace Application.Image.Commands.BatchUploadImages;

public sealed class BatchUploadImagesCommandValidator : AbstractValidator<BatchUploadImagesCommand>
{
    public BatchUploadImagesCommandValidator()
    {
        RuleFor(x => x.LeadId)
            .NotEmpty();

        RuleFor(x => x.Items)
            .NotNull()
            .NotEmpty()
            .WithMessage("At least one image is required.")
            .Must(items => items.Count <= 10)
            .WithMessage("Cannot upload more than 10 images at a time.");

        RuleForEach(x => x.Items).ChildRules(item =>
        {
            item.RuleFor(i => i.Base64Image)
                .NotEmpty()
                .MinimumLength(ImageConstants.MIN_BASE64_LENGTH);

            item.RuleFor(i => i.FileName)
                .NotEmpty()
                .MaximumLength(ImageConstants.MAX_FILE_NAME_LENGTH);
        });
    }
}

