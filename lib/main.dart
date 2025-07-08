import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:railway_report/screen/metadata_screen.dart';
import 'providers/form_provider.dart';

void main() {
  runApp(const RailwayScoreApp());
}

class RailwayScoreApp extends StatelessWidget {
  const RailwayScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormProvider()..loadFromPrefs(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Railway Scorecard',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const MetadataScreen(),
      ),
    );
  }
}
