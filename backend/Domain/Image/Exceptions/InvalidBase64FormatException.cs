namespace Domain.Image.Exceptions;

public class InvalidBase64FormatException : DomainException
{
    public InvalidBase64FormatException(string message)
        : base(message)
    {
    }

    public InvalidBase64FormatException(string message, Exception innerException)
        : base(message, innerException)
    {
    }
}

public abstract class DomainException : Exception
{
    protected DomainException(string message)
        : base(message)
    {
    }

    protected DomainException(string message, Exception innerException)
        : base(message, innerException)
    {
    }
}