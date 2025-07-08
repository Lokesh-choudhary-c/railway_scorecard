import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:railway_report/models/parameter_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FormProvider with ChangeNotifier {
  String station = '';
  String supervisor = '';
  String train = '';
  String coach = '';
  String toilet = '';
  String doorway = '';
  String date = '';
  List<ParameterModel> parameters = [];

  void setMetadata({required String key, required String value}) {
    switch (key) {
      case 'station':
        station = value;
        break;
      case 'supervisor':
        supervisor = value;
        break;
      case 'train':
        train = value;
        break;
      case 'coach':
        coach = value;
        break;
      case 'toilet':
        toilet = value;
        break;
      case 'doorway':
        doorway = value;
        break;
      case 'date':
        date = value;
        break;
    }
    saveToPrefs();
    notifyListeners();
  }

  void initializeParameters() {
    if (parameters.isEmpty) {
      parameters = [
        'Platform Cleanliness',
        'Urinal Cleanliness',
        'Water Booth Condition',
        'Dustbin Availability',
        'Waiting Room Cleanliness',
        'Drainage Smell'
      ].map((e) => ParameterModel(title: e)).toList();
    }
    saveToPrefs();
  }

  void updateScore(int index, int score) {
    parameters[index].score = score;
    saveToPrefs();
    notifyListeners();
  }

  void updateRemarks(int index, String remark) {
    parameters[index].remarks = remark;
    saveToPrefs();
    notifyListeners();
  }

  Map<String, dynamic> getFormData() {
    return {
      'station': station,
      'supervisor': supervisor,
      'train': train,
      'coach': coach,
      'toilet': toilet,
      'doorway': doorway,
      'date': date,
      'parameters': parameters.map((e) => e.toJson()).toList(),
    };
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('metadata', jsonEncode(getFormData()));
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final meta = prefs.getString('metadata');
    if (meta != null) {
      final m = jsonDecode(meta);
      station = m['station'];
      supervisor = m['supervisor'];
      train = m['train'];
      coach = m['coach'];
      toilet = m['toilet'];
      doorway = m['doorway'];
      date = m['date'];
      parameters = (m['parameters'] as List)
          .map((e) => ParameterModel.fromJson(e))
          .toList();
    }
    notifyListeners();
  }

  void clearForm() async {
    station = '';
    supervisor = '';
    train = '';
    coach = '';
    toilet = '';
    doorway = '';
    date = '';
    parameters = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
