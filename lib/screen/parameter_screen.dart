import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:railway_report/providers/form_provider.dart';
import 'package:railway_report/widgets/parameter_widget.dart';
import 'summary_screen.dart';

class ParameterScreen extends StatefulWidget {
  const ParameterScreen({super.key});

  @override
  State<ParameterScreen> createState() => _ParameterScreenState();
}

class _ParameterScreenState extends State<ParameterScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<FormProvider>(context, listen: false).initializeParameters();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FormProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Score Parameters'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: provider.parameters.length,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ParameterWidget(index: i),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SummaryScreen()));
        },
        icon: const Icon(Icons.arrow_forward_ios),
        label: const Text('Preview & Submit'),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.black,
      ),
    );
  }
}
