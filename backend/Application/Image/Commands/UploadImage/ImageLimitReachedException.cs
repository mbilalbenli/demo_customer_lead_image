using Domain.Lead.Constants;

namespace Application.Image.Commands.UploadImage;

public class ImageLimitReachedException : Exception
{
    public int CurrentImageCount { get; }
    public int MaxImageCount { get; }
    public Guid LeadId { get; }

    public ImageLimitReachedException(Guid leadId, int currentCount)
        : base($"You've reached the maximum of {LeadConstants.MAX_IMAGES_PER_LEAD} images for this lead. " +
               $"Current image count: {currentCount}. " +
               $"Would you like to replace an existing image? Please delete an image first or use the replace functionality.")
    {
        LeadId = leadId;
        CurrentImageCount = currentCount;
        MaxImageCount = LeadConstants.MAX_IMAGES_PER_LEAD;
    }

    public ImageLimitReachedException(Guid leadId, int currentCount, int attemptedToAdd)
        : base($"Cannot add {attemptedToAdd} image(s). Lead has {currentCount} image(s) and the maximum is {LeadConstants.MAX_IMAGES_PER_LEAD}. " +
               $"You can add at most {LeadConstants.MAX_IMAGES_PER_LEAD - currentCount} more image(s).")
    {
        LeadId = leadId;
        CurrentImageCount = currentCount;
        MaxImageCount = LeadConstants.MAX_IMAGES_PER_LEAD;
    }
}