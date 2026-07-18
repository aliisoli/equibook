import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../models/models.dart';
import '../../widgets/common.dart';

class HorseFormScreen extends StatefulWidget {
  const HorseFormScreen({
    super.key,
    required this.horse,
    this.isNew = false,
  });

  final Horse horse;
  final bool isNew;

  @override
  State<HorseFormScreen> createState() => _HorseFormScreenState();
}

class _HorseFormScreenState extends State<HorseFormScreen> {
  late final TextEditingController _name;
  late final TextEditingController _breed;
  late final TextEditingController _notes;
  String? _photoPath;
  String? _docPath;
  String? _docName;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.horse.name);
    _breed = TextEditingController(text: widget.horse.breed);
    _notes = TextEditingController(text: widget.horse.notes);
    _photoPath = widget.horse.photoPath;
    _docPath = widget.horse.ownershipDocPath;
    _docName = widget.horse.ownershipDocName;
  }

  @override
  void dispose() {
    _name.dispose();
    _breed.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<String> _persistFile(String sourcePath, String prefix) async {
    if (kIsWeb) return sourcePath;
    final dir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory(p.join(dir.path, 'media'));
    if (!await mediaDir.exists()) await mediaDir.create(recursive: true);
    final dest = p.join(
      mediaDir.path,
      '${prefix}_${DateTime.now().millisecondsSinceEpoch}${p.extension(sourcePath)}',
    );
    await File(sourcePath).copy(dest);
    return dest;
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    final saved = await _persistFile(picked.path, 'horse');
    setState(() => _photoPath = saved);
  }

  Future<void> _pickDoc() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (result == null || result.files.single.path == null) return;
    final path = result.files.single.path!;
    final saved = await _persistFile(path, 'ownership');
    setState(() {
      _docPath = saved;
      _docName = result.files.single.name;
    });
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Horse name is required.')),
      );
      return;
    }
    setState(() => _busy = true);
    await context.read<AppStore>().upsertHorse(
      widget.horse.copyWith(
        name: _name.text.trim(),
        breed: _breed.text.trim(),
        notes: _notes.text.trim(),
        photoPath: _photoPath,
        ownershipDocPath: _docPath,
        ownershipDocName: _docName,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete horse?'),
        content: Text('Remove ${widget.horse.name} from your stable?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await context.read<AppStore>().deleteHorse(widget.horse.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? 'Add horse' : 'Edit horse'),
        actions: [
          if (!widget.isNew)
            IconButton(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickPhoto,
              child: Column(
                children: [
                  LocalImage(
                    path: _photoPath,
                    size: 120,
                    borderRadius: 20,
                    fallbackIcon: Icons.add_a_photo_outlined,
                  ),
                  const SizedBox(height: 8),
                  const Text('Tap to add photo'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _breed,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Breed (optional)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Notes (optional)'),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.description_outlined),
            title: Text(_docName ?? 'Ownership document'),
            subtitle: Text(
              _docPath == null
                  ? 'PDF or image of ownership papers'
                  : 'Attached',
            ),
            trailing: TextButton(
              onPressed: _pickDoc,
              child: Text(_docPath == null ? 'Upload' : 'Replace'),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(_busy ? 'Saving…' : 'Save horse'),
          ),
        ],
      ),
    );
  }
}
