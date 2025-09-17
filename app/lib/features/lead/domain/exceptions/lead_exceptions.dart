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

/// Exception thrown when lead creation fails
class LeadCreationException extends LeadException {
  const LeadCreationException({
    required super.message,
    super.originalError,
  }) : super(
          code: 'LEAD_CREATION_FAILED',
        );
}

/// Exception thrown when lead update fails
class LeadUpdateException extends LeadException {
  const LeadUpdateException({
    required super.message,
    super.originalError,
  }) : super(
          code: 'LEAD_UPDATE_FAILED',
        );
}

/// Exception thrown when lead deletion fails
class LeadDeletionException extends LeadException {
  const LeadDeletionException({
    required super.message,
    super.originalError,
  }) : super(
          code: 'LEAD_DELETION_FAILED',
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

/// Exception thrown when lead validation fails
class LeadValidationException extends LeadException {
  final Map<String, List<String>> validationErrors;

  const LeadValidationException({
    required super.message,
    required this.validationErrors,
    super.originalError,
  }) : super(
          code: 'LEAD_VALIDATION_FAILED',
        );

  @override
  String toString() {
    final errors = validationErrors.entries
        .map((e) => '${e.key}: ${e.value.join(', ')}')
        .join('; ');
    return 'LeadValidationException: $message - $errors';
  }
}