enum UserRole { owner, vet }

enum BookingStatus { pending, confirmed, declined, completed, cancelled }

/// Marketplace service families shown on the owner home.
enum ServiceCategory {
  veterinary,
  farriery,
  ridingClass,
  clubManagement,
  shop,
}

extension ServiceCategoryX on ServiceCategory {
  bool get isBookable =>
      this == ServiceCategory.veterinary || this == ServiceCategory.farriery;

  /// Provider specialty for bookable categories.
  bool get isProviderCategory => isBookable;
}

enum ReminderKind {
  vaccine,
  deworming,
  pregnancyTest,
  other,
}

extension BookingStatusLabel on BookingStatus {
  String get label => switch (this) {
    BookingStatus.pending => 'Pending',
    BookingStatus.confirmed => 'Confirmed',
    BookingStatus.declined => 'Declined',
    BookingStatus.completed => 'Completed',
    BookingStatus.cancelled => 'Cancelled',
  };
}
