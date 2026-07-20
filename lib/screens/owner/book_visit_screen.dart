import 'package:flutter/material.dart';

import 'book_service_screen.dart';

class BookVisitScreen extends StatelessWidget {
  const BookVisitScreen({super.key, required this.vetId});

  final String vetId;

  @override
  Widget build(BuildContext context) {
    return BookServiceScreen(providerId: vetId);
  }
}
