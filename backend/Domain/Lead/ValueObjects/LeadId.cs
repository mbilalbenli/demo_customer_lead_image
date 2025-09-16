namespace Domain.Lead.ValueObjects;

public sealed class LeadId : IEquatable<LeadId>
{
    public Guid Value { get; }

    private LeadId(Guid value)
    {
        if (value == Guid.Empty)
            throw new ArgumentException("Lead ID cannot be empty.", nameof(value));

        Value = value;
    }

    public static LeadId Create() => new(Guid.NewGuid());

    public static LeadId From(Guid value) => new(value);

    public static LeadId From(string value)
    {
        if (!Guid.TryParse(value, out var guid))
            throw new ArgumentException($"Invalid Lead ID format: {value}", nameof(value));

        return new LeadId(guid);
    }

    public override bool Equals(object? obj) => obj is LeadId other && Equals(other);

    public bool Equals(LeadId? other) => other is not null && Value == other.Value;

    public override int GetHashCode() => Value.GetHashCode();

    public override string ToString() => Value.ToString();

    public static implicit operator Guid(LeadId id) => id.Value;

    public static bool operator ==(LeadId? left, LeadId? right) => Equals(left, right);

    public static bool operator !=(LeadId? left, LeadId? right) => !Equals(left, right);
}