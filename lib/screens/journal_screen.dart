import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metron/providers/journal_provider.dart';
import 'package:metron/models/journal_entry.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _entryCtrl = TextEditingController();

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  Future<void> _showAddEntryDialog(BuildContext context) async {
    _entryCtrl.clear();
    final prov = Provider.of<JournalProvider>(context, listen: false);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Journal Entry'),
        content: TextField(
          controller: _entryCtrl,
          decoration:
              const InputDecoration(labelText: 'Write your reflection...'),
          minLines: 3,
          maxLines: 6,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_entryCtrl.text.trim().isEmpty) return;
              await prov.addEntry(_entryCtrl.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<JournalProvider>(context);
    final entries = prov.entries;

    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      body: RefreshIndicator(
        onRefresh: prov.loadEntries,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: entries.length,
          itemBuilder: (_, idx) {
            final e = entries[idx];
            return Card(
              child: ListTile(
                title:
                    Text(e.entry, maxLines: 3, overflow: TextOverflow.ellipsis),
                subtitle: Text(e.createdAt),
                trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => prov.deleteEntry(e.id!)),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Journal Entry'),
                    content: SingleChildScrollView(child: Text(e.entry)),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'))
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEntryDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
