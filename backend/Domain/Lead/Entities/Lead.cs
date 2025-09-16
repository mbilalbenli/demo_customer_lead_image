using Domain.Image.Entities;
using Domain.Image.ValueObjects;
using Domain.Lead.Constants;
using Domain.Lead.Enums;
using Domain.Lead.ValueObjects;

namespace Domain.Lead.Entities;

public sealed class Lead
{
    private readonly List<LeadImage> _images = new();

    // Private constructor for encapsulation
    private Lead(
        LeadId id,
        CustomerName name,
        EmailAddress email,
        PhoneNumber phone,
        LeadStatus status,
        DateTime createdAt,
        DateTime? updatedAt = null)
    {
        Id = id;
        Name = name;
        Email = email;
        Phone = phone;
        Status = status;
        CreatedAt = createdAt;
        UpdatedAt = updatedAt ?? createdAt;
    }

    public LeadId Id { get; private set; }
    public CustomerName Name { get; private set; }
    public EmailAddress Email { get; private set; }
    public PhoneNumber Phone { get; private set; }
    public LeadStatus Status { get; private set; }
    public DateTime CreatedAt { get; private set; }
    public DateTime UpdatedAt { get; private set; }
    public IReadOnlyList<LeadImage> Images => _images.AsReadOnly();

    // Factory method for creating new leads
    public static Lead Create(
        string name,
        string email,
        string phone,
        LeadStatus status = LeadStatus.New)
    {
        var lead = new Lead(
            LeadId.Create(),
            CustomerName.Create(name),
            EmailAddress.Create(email),
            PhoneNumber.Create(phone),
            status,
            DateTime.UtcNow
        );

        return lead;
    }

    // Factory method for reconstitution from persistence
    public static Lead Reconstitute(
        Guid id,
        string name,
        string email,
        string phone,
        LeadStatus status,
        DateTime createdAt,
        DateTime updatedAt,
        List<LeadImage>? images = null)
    {
        var lead = new Lead(
            LeadId.From(id),
            CustomerName.Create(name),
            EmailAddress.Create(email),
            PhoneNumber.Create(phone),
            status,
            createdAt,
            updatedAt
        );

        if (images?.Any() == true)
        {
            lead._images.AddRange(images);
        }

        return lead;
    }

    // Business methods for image management
    public bool CanAddImage()
    {
        return _images.Count < LeadConstants.MAX_IMAGES_PER_LEAD;
    }

    public int GetImageCount()
    {
        return _images.Count;
    }

    public int GetAvailableImageSlots()
    {
        return LeadConstants.MAX_IMAGES_PER_LEAD - _images.Count;
    }

    public Result<LeadImage> TryAddImage(LeadImage image)
    {
        if (image == null)
            return Result<LeadImage>.Failure("Image cannot be null.");

        if (!CanAddImage())
        {
            return Result<LeadImage>.Failure(
                $"Cannot add more images. Maximum limit of {LeadConstants.MAX_IMAGES_PER_LEAD} images reached. " +
                $"Please delete an existing image before adding a new one.");
        }

        if (_images.Any(i => i.Id == image.Id))
            return Result<LeadImage>.Failure("Image already exists for this lead.");

        _images.Add(image);
        UpdatedAt = DateTime.UtcNow;

        return Result<LeadImage>.Success(image);
    }

    public Result<LeadImage> ReplaceImage(Guid oldImageId, LeadImage newImage)
    {
        if (newImage == null)
            return Result<LeadImage>.Failure("New image cannot be null.");

        var existingImage = _images.FirstOrDefault(i => i.Id.Value == oldImageId);
        if (existingImage == null)
            return Result<LeadImage>.Failure($"Image with ID {oldImageId} not found.");

        _images.Remove(existingImage);
        _images.Add(newImage);
        UpdatedAt = DateTime.UtcNow;

        return Result<LeadImage>.Success(newImage);
    }

    public Result RemoveImage(Guid imageId)
    {
        var image = _images.FirstOrDefault(i => i.Id.Value == imageId);
        if (image == null)
            return Result.Failure($"Image with ID {imageId} not found.");

        _images.Remove(image);
        UpdatedAt = DateTime.UtcNow;

        return Result.Success();
    }

    public void ClearAllImages()
    {
        _images.Clear();
        UpdatedAt = DateTime.UtcNow;
    }

    // Business methods for lead management
    public void UpdateContactInfo(string? name = null, string? email = null, string? phone = null)
    {
        if (!string.IsNullOrWhiteSpace(name))
            Name = CustomerName.Create(name);

        if (!string.IsNullOrWhiteSpace(email))
            Email = EmailAddress.Create(email);

        if (!string.IsNullOrWhiteSpace(phone))
            Phone = PhoneNumber.Create(phone);

        UpdatedAt = DateTime.UtcNow;
    }

    public void UpdateStatus(LeadStatus newStatus)
    {
        if (Status != newStatus)
        {
            Status = newStatus;
            UpdatedAt = DateTime.UtcNow;
        }
    }

    public bool IsQualified()
    {
        return Status is LeadStatus.Qualified or LeadStatus.Proposal or LeadStatus.Negotiation;
    }

    public bool IsClosed()
    {
        return Status is LeadStatus.Closed or LeadStatus.Lost;
    }
}

// Result pattern for better error handling
public class Result
{
    public bool IsSuccess { get; }
    public string? Error { get; }

    protected Result(bool isSuccess, string? error)
    {
        IsSuccess = isSuccess;
        Error = error;
    }

    public static Result Success() => new(true, null);
    public static Result Failure(string error) => new(false, error);
}

public class Result<T> : Result
{
    public T? Value { get; }

    private Result(bool isSuccess, T? value, string? error) : base(isSuccess, error)
    {
        Value = value;
    }

    public static Result<T> Success(T value) => new(true, value, null);
    public static new Result<T> Failure(string error) => new(false, default, error);
}

