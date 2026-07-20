import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../models/models.dart';
import '../../settings/app_settings.dart';
import '../../utils/app_dates.dart';
import '../../widgets/common.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final s = context.watch<AppSettings>().strings;
    final dates = AppDates.watch(context);
    final vetId = store.currentUser!.id;
    final services = store.servicesFor(vetId);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.servicesAndRates),
        actions: [
          IconButton(
            onPressed: () =>
                _openForm(context, store.newServiceDraft(vetId), true),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: services.isEmpty
          ? EmptyState(
              icon: Icons.medical_services_outlined,
              title: s.noServicesListed,
              message: s.noServicesMessage,
              action: FilledButton(
                onPressed: () =>
                    _openForm(context, store.newServiceDraft(vetId), true),
                child: Text(s.addService),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  child: ListTile(
                    title: Text(service.title),
                    subtitle: Text(
                      '${s.minutesLabel(service.durationMinutes)}'
                      '${service.description.isEmpty ? '' : ' · ${service.description}'}',
                    ),
                    trailing: Text(dates.formatMoney(service.rate)),
                    onTap: () => _openForm(context, service, false),
                  ),
                );
              },
            ),
    );
  }

  void _openForm(BuildContext context, ServiceOffering service, bool isNew) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ServiceFormScreen(service: service, isNew: isNew),
      ),
    );
  }
}

class ServiceFormScreen extends StatefulWidget {
  const ServiceFormScreen({
    super.key,
    required this.service,
    this.isNew = false,
  });

  final ServiceOffering service;
  final bool isNew;

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _rate;
  late final TextEditingController _duration;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.service.title);
    _description = TextEditingController(text: widget.service.description);
    _rate = TextEditingController(
      text: widget.service.rate == 0
          ? ''
          : widget.service.rate.toStringAsFixed(0),
    );
    _duration = TextEditingController(
      text: widget.service.durationMinutes.toString(),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _rate.dispose();
    _duration.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final s = context.read<AppSettings>().strings;
    final rate = double.tryParse(_rate.text.trim());
    final duration = int.tryParse(_duration.text.trim());
    if (_title.text.trim().isEmpty ||
        rate == null ||
        rate <= 0 ||
        duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.serviceValidation)),
      );
      return;
    }
    setState(() => _busy = true);
    await context.read<AppStore>().upsertService(
      widget.service.copyWith(
        title: _title.text.trim(),
        description: _description.text.trim(),
        rate: rate,
        durationMinutes: duration,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettings>().strings;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? s.addService : s.editService),
        actions: [
          if (!widget.isNew)
            IconButton(
              onPressed: () async {
                await context.read<AppStore>().deleteService(widget.service.id);
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: s.serviceTitle),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            maxLines: 3,
            decoration: InputDecoration(labelText: s.description),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _rate,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: s.cashRateUsd,
              prefixText: '\$ ',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _duration,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: s.durationMinutes),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(_busy ? s.saving : s.saveService),
          ),
        ],
      ),
    );
  }
}
