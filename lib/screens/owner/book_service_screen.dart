import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../settings/app_settings.dart';
import '../../utils/app_dates.dart';

class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({super.key, required this.providerId});

  final String providerId;

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  String? _horseId;
  String? _serviceId;
  String? _slotId;
  final _notes = TextEditingController();
  bool _rateConfirmed = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final store = context.read<AppStore>();
    final s = context.read<AppSettings>().strings;
    final owner = store.currentUser!;
    setState(() {
      _busy = true;
      _error = null;
    });
    final error = await store.createBooking(
      ownerId: owner.id,
      vetId: widget.providerId,
      horseId: _horseId!,
      serviceId: _serviceId!,
      slotId: _slotId!,
      rateConfirmedByOwner: _rateConfirmed,
      notes: _notes.text.trim(),
    );
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _error = error;
        _busy = false;
      });
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s.bookingSent)),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final s = context.watch<AppSettings>().strings;
    final dates = AppDates.watch(context);
    final horses = store.horsesFor(store.currentUser!.id);
    final services = store.servicesFor(widget.providerId);
    final slots = store.openSlotsFor(widget.providerId);
    final selectedService =
        _serviceId == null ? null : store.serviceById(_serviceId!);

    return Scaffold(
      appBar: AppBar(title: Text(s.bookAVisit)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(s.horse, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (horses.isEmpty)
            Text(s.addHorseBeforeBooking)
          else
            ...horses.map(
              (horse) => RadioListTile<String>(
                value: horse.id,
                groupValue: _horseId,
                onChanged: (value) => setState(() => _horseId = value),
                title: Text(horse.name),
                subtitle: horse.breed.isEmpty ? null : Text(horse.breed),
              ),
            ),
          const SizedBox(height: 16),
          Text(s.service, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...services.map(
            (service) => RadioListTile<String>(
              value: service.id,
              groupValue: _serviceId,
              onChanged: (value) => setState(() {
                _serviceId = value;
                _rateConfirmed = false;
              }),
              title: Text(service.title),
              subtitle: Text(dates.formatMoney(service.rate)),
            ),
          ),
          const SizedBox(height: 16),
          Text(s.timeSlot, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...slots.map(
            (slot) => RadioListTile<String>(
              value: slot.id,
              groupValue: _slotId,
              onChanged: (value) => setState(() => _slotId = value),
              title: Text(dates.formatDateTime(slot.start)),
              subtitle: Text(s.untilTime(dates.formatTime(slot.end))),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notes,
            maxLines: 3,
            decoration: InputDecoration(labelText: s.notesForVet),
          ),
          if (selectedService != null) ...[
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.rateToConfirm,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dates.formatMoney(selectedService.rate),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(s.cashConfirmHint),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _rateConfirmed,
                      onChanged: (value) =>
                          setState(() => _rateConfirmed = value ?? false),
                      title: Text(
                        s.confirmRate(dates.formatMoney(selectedService.rate)),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: Colors.red.shade700)),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _busy ||
                    _horseId == null ||
                    _serviceId == null ||
                    _slotId == null ||
                    !_rateConfirmed
                ? null
                : _submit,
            child: Text(_busy ? s.sending : s.requestBooking),
          ),
        ],
      ),
    );
  }
}
