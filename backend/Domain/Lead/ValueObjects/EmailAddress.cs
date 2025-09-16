using System.Text.RegularExpressions;
using Domain.Lead.Constants;

namespace Domain.Lead.ValueObjects;

public sealed partial class EmailAddress : IEquatable<EmailAddress>
{
    private static readonly Regex EmailRegex = GeneratedEmailRegex();

    public string Value { get; }

    private EmailAddress(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
            throw new ArgumentException("Email address cannot be empty.", nameof(value));

        value = value.Trim().ToLowerInvariant();

        if (value.Length > LeadConstants.MAX_EMAIL_LENGTH)
            throw new ArgumentException($"Email address cannot exceed {LeadConstants.MAX_EMAIL_LENGTH} characters.", nameof(value));

        if (!EmailRegex.IsMatch(value))
            throw new ArgumentException($"Invalid email address format: {value}", nameof(value));

        Value = value;
    }

    public static EmailAddress Create(string value) => new(value);

    public string GetDomain() => Value.Split('@')[1];

    public override bool Equals(object? obj) => obj is EmailAddress other && Equals(other);

    public bool Equals(EmailAddress? other) =>
        other is not null && Value.Equals(other.Value, StringComparison.OrdinalIgnoreCase);

    public override int GetHashCode() => Value.GetHashCode();

    public override string ToString() => Value;

    public static implicit operator string(EmailAddress email) => email.Value;

    public static bool operator ==(EmailAddress? left, EmailAddress? right) => Equals(left, right);

    public static bool operator !=(EmailAddress? left, EmailAddress? right) => !Equals(left, right);

    [GeneratedRegex(@"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", RegexOptions.Compiled)]
    private static partial Regex GeneratedEmailRegex();
}