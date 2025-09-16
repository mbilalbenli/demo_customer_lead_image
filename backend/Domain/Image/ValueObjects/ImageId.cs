namespace Domain.Image.ValueObjects;

public sealed class ImageId : IEquatable<ImageId>
{
    public Guid Value { get; }

    private ImageId(Guid value)
    {
        if (value == Guid.Empty)
            throw new ArgumentException("Image ID cannot be empty.", nameof(value));

        Value = value;
    }

    public static ImageId Create() => new(Guid.NewGuid());

    public static ImageId From(Guid value) => new(value);

    public static ImageId From(string value)
    {
        if (!Guid.TryParse(value, out var guid))
            throw new ArgumentException($"Invalid Image ID format: {value}", nameof(value));

        return new ImageId(guid);
    }

    public override bool Equals(object? obj) => obj is ImageId other && Equals(other);

    public bool Equals(ImageId? other) => other is not null && Value == other.Value;

    public override int GetHashCode() => Value.GetHashCode();

    public override string ToString() => Value.ToString();

    public static implicit operator Guid(ImageId id) => id.Value;

    public static bool operator ==(ImageId? left, ImageId? right) => Equals(left, right);

    public static bool operator !=(ImageId? left, ImageId? right) => !Equals(left, right);
}