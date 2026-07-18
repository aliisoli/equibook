enum UserRole { owner, vet }

enum BookingStatus { pending, confirmed, declined, completed, cancelled }

extension BookingStatusLabel on BookingStatus {
  String get label => switch (this) {
    BookingStatus.pending => 'Pending',
    BookingStatus.confirmed => 'Confirmed',
    BookingStatus.declined => 'Declined',
    BookingStatus.completed => 'Completed',
    BookingStatus.cancelled => 'Cancelled',
  };
}
