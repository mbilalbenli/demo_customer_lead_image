using Domain.Lead.Constants;

namespace Domain.Lead.ValueObjects;

public sealed class CustomerName : IEquatable<CustomerName>
{
    public string Value { get; }

    private CustomerName(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
            throw new ArgumentException("Customer name cannot be empty.", nameof(value));

        if (value.Length < LeadConstants.MIN_NAME_LENGTH)
            throw new ArgumentException($"Customer name must be at least {LeadConstants.MIN_NAME_LENGTH} characters.", nameof(value));

        if (value.Length > LeadConstants.MAX_NAME_LENGTH)
            throw new ArgumentException($"Customer name cannot exceed {LeadConstants.MAX_NAME_LENGTH} characters.", nameof(value));

        Value = value.Trim();
    }

    public static CustomerName Create(string value) => new(value);

    public override bool Equals(object? obj) => obj is CustomerName other && Equals(other);

    public bool Equals(CustomerName? other) =>
        other is not null && Value.Equals(other.Value, StringComparison.OrdinalIgnoreCase);

    public override int GetHashCode() => Value.ToLowerInvariant().GetHashCode();

    public override string ToString() => Value;

    public static implicit operator string(CustomerName name) => name.Value;

    public static bool operator ==(CustomerName? left, CustomerName? right) => Equals(left, right);

    public static bool operator !=(CustomerName? left, CustomerName? right) => !Equals(left, right);
}