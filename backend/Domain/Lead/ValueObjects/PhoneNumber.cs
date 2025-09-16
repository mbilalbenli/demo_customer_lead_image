using System.Text.RegularExpressions;
using Domain.Lead.Constants;

namespace Domain.Lead.ValueObjects;

public sealed partial class PhoneNumber : IEquatable<PhoneNumber>
{
    private static readonly Regex PhoneRegex = GeneratedPhoneRegex();

    public string Value { get; }

    private PhoneNumber(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
            throw new ArgumentException("Phone number cannot be empty.", nameof(value));

        // Remove common formatting characters
        value = value.Replace(" ", "")
                    .Replace("-", "")
                    .Replace("(", "")
                    .Replace(")", "")
                    .Replace(".", "")
                    .Trim();

        if (value.Length > LeadConstants.MAX_PHONE_LENGTH)
            throw new ArgumentException($"Phone number cannot exceed {LeadConstants.MAX_PHONE_LENGTH} characters.", nameof(value));

        if (!PhoneRegex.IsMatch(value))
            throw new ArgumentException($"Invalid phone number format: {value}", nameof(value));

        Value = value;
    }

    public static PhoneNumber Create(string value) => new(value);

    public string GetFormatted()
    {
        // Simple US phone format, can be expanded for international
        if (Value.Length == 10)
            return $"({Value[..3]}) {Value.Substring(3, 3)}-{Value.Substring(6)}";

        return Value;
    }

    public override bool Equals(object? obj) => obj is PhoneNumber other && Equals(other);

    public bool Equals(PhoneNumber? other) =>
        other is not null && Value.Equals(other.Value, StringComparison.OrdinalIgnoreCase);

    public override int GetHashCode() => Value.GetHashCode();

    public override string ToString() => Value;

    public static implicit operator string(PhoneNumber phone) => phone.Value;

    public static bool operator ==(PhoneNumber? left, PhoneNumber? right) => Equals(left, right);

    public static bool operator !=(PhoneNumber? left, PhoneNumber? right) => !Equals(left, right);

    [GeneratedRegex(@"^\+?[1-9]\d{1,14}$", RegexOptions.Compiled)]
    private static partial Regex GeneratedPhoneRegex();
}