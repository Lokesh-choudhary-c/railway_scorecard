// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:railway_report/providers/form_provider.dart';
import 'package:railway_report/screen/pdf_list_screen.dart';
import 'parameter_screen.dart';

class MetadataScreen extends StatefulWidget {
  const MetadataScreen({super.key});

  @override
  State<MetadataScreen> createState() => _MetadataScreenState();
}

class _MetadataScreenState extends State<MetadataScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FormProvider>(context);
    return Scaffold(
      appBar: AppBar(
  title: const Text('Inspection Metadata'),
  backgroundColor: Colors.pinkAccent,
  actions: [
    IconButton(
      icon: const Icon(Icons.folder),
      tooltip: 'View Saved PDFs',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PdfListScreen()),
        );
      },
    ),
  ],
),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyanAccent, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _textInput('Station Name', 'station', provider),
              _textInput('Supervisor', 'supervisor', provider),
              _textInput('Train Number', 'train', provider),
              _dropdownInput('Coach Number', 'coach', provider,
                  List.generate(13, (i) => 'C${i + 1}')),
              _dropdownInput('Toilet Number', 'toilet', provider,
                  List.generate(4, (i) => 'T${i + 1}')),
              _dropdownInput('Doorway Number', 'doorway', provider, ['D1', 'D2']),
              const SizedBox(height: 12),
              ListTile(
                tileColor: Colors.white24,
                title: Text(
                    selectedDate == null
                        ? 'Pick Inspection Date'
                        : '📅 ${selectedDate!.toLocal()}'.split(' ')[0],
                    style: const TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.calendar_month, color: Colors.white),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                    provider.setMetadata(
                        key: 'date', value: picked.toIso8601String());
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      selectedDate != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ParameterScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please complete all fields')),
                    );
                  }
                },
                child: const Text('Continue ➡️'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textInput(String label, String key, FormProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.black.withOpacity(0.2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        ),
        style: const TextStyle(color: Colors.white),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        onChanged: (val) => provider.setMetadata(key: key, value: val),
      ),
    );
  }

  Widget _dropdownInput(String label, String key, FormProvider provider, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.black.withOpacity(0.2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        ),
        dropdownColor: Colors.black,
        style: const TextStyle(color: Colors.white),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(color: Colors.white)),
                ))
            .toList(),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        onChanged: (val) => provider.setMetadata(key: key, value: val!),
      ),
    );
  }
}




