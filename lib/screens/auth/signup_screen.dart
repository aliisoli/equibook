import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../models/models.dart';
import '../../settings/app_settings.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  UserRole _role = UserRole.owner;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final error = await context.read<AppStore>().signUp(
      email: _email.text,
      password: _password.text,
      name: _name.text,
      role: _role,
      phone: _phone.text,
    );
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _error = error;
        _busy = false;
      });
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettings>().strings;
    return Scaffold(
      appBar: AppBar(title: Text(s.createAccount)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(s.iAmA, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<UserRole>(
            segments: [
              ButtonSegment(
                value: UserRole.owner,
                label: Text(s.horseOwner),
                icon: const Icon(Icons.pets),
              ),
              ButtonSegment(
                value: UserRole.vet,
                label: Text(s.veterinarian),
                icon: const Icon(Icons.medical_services_outlined),
              ),
            ],
            selected: {_role},
            onSelectionChanged: (value) => setState(() => _role = value.first),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: s.fullName),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: s.email),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: s.phoneOptional),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(labelText: s.password),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: Colors.red.shade700)),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: Text(_busy ? s.creating : s.signUp),
          ),
        ],
      ),
    );
  }
}
