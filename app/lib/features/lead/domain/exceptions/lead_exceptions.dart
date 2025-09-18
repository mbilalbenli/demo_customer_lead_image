/// Base exception for lead-related errors
abstract class LeadException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const LeadException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'LeadException: $message ${code != null ? '(Code: $code)' : ''}';
}

/// Exception thrown when a lead is not found
class LeadNotFoundException extends LeadException {
  const LeadNotFoundException({
    required String leadId,
    super.originalError,
  }) : super(
          message: 'Lead with ID $leadId not found',
          code: 'LEAD_NOT_FOUND',
        );
}

/// Exception thrown when lead search fails
class LeadSearchException extends LeadException {
  const LeadSearchException({
    required super.message,
    super.originalError,
  }) : super(
          code: 'LEAD_SEARCH_FAILED',
        );
}

/// Exception thrown when lead creation fails
class LeadCreationException extends LeadException {
  const LeadCreationException({
    required super.message,
    super.originalError,
  }) : super(
          code: 'LEAD_CREATION_FAILED',
        );
}
