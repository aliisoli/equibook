import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../widgets/common.dart';

class BookVisitScreen extends StatefulWidget {
  const BookVisitScreen({super.key, required this.vetId});

  final String vetId;

  @override
  State<BookVisitScreen> createState() => _BookVisitScreenState();
}

class _BookVisitScreenState extends State<BookVisitScreen> {
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
    final owner = store.currentUser!;
    setState(() {
      _busy = true;
      _error = null;
    });
    final error = await store.createBooking(
      ownerId: owner.id,
      vetId: widget.vetId,
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
      const SnackBar(content: Text('Booking request sent to the vet.')),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final horses = store.horsesFor(store.currentUser!.id);
    final services = store.servicesFor(widget.vetId);
    final slots = store.openSlotsFor(widget.vetId);
    final selectedService = _serviceId == null
        ? null
        : store.serviceById(_serviceId!);

    return Scaffold(
      appBar: AppBar(title: const Text('Book a visit')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Horse', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (horses.isEmpty)
            const Text('Add a horse before booking.')
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
          Text('Service', style: Theme.of(context).textTheme.titleMedium),
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
              subtitle: Text(moneyFormat.format(service.rate)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Time slot', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...slots.map(
            (slot) => RadioListTile<String>(
              value: slot.id,
              groupValue: _slotId,
              onChanged: (value) => setState(() => _slotId = value),
              title: Text(dateTimeFormat.format(slot.start)),
              subtitle: Text('Until ${timeFormat.format(slot.end)}'),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notes,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes for the vet (optional)',
            ),
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
                      'Rate to confirm',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      moneyFormat.format(selectedService.rate),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Payment is handled offline in cash. Confirm that you accept this rate.',
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _rateConfirmed,
                      onChanged: (value) =>
                          setState(() => _rateConfirmed = value ?? false),
                      title: Text(
                        'I confirm the rate of ${moneyFormat.format(selectedService.rate)}',
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
            child: Text(_busy ? 'Sending…' : 'Request booking'),
          ),
        ],
      ),
    );
  }
}
