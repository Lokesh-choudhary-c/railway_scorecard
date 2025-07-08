import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:railway_report/providers/form_provider.dart';


class ParameterWidget extends StatelessWidget {
  final int index;

  const ParameterWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final form = Provider.of<FormProvider>(context);
    final parameter = form.parameters[index];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(parameter.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: parameter.score,
              items: List.generate(
                11,
                (i) => DropdownMenuItem(value: i, child: Text("$i")),
              ),
              onChanged: (val) {
                form.updateScore(index, val ?? 0);
              },
              decoration: const InputDecoration(
                labelText: "Score (0–10)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: parameter.remarks,
              onChanged: (val) => form.updateRemarks(index, val),
              decoration: const InputDecoration(
                labelText: "Remarks (Optional)",
                border: OutlineInputBorder(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
