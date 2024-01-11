import 'package:flutter/material.dart';
import 'package:mreminderapp/models/medicine_type.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/errors.dart';

class NewEntryBloc {
  BehaviorSubject<MedicineType>? _selectedMedicineTypeStream;
  ValueStream<MedicineType>? get selectedMedicineType =>
      _selectedMedicineTypeStream!.stream;

  BehaviorSubject<int>? _selectedIntervalStream;
  BehaviorSubject<int>? get selectedInterval => _selectedIntervalStream;

  BehaviorSubject<String>? _selectedTimeOfDayStream;
  BehaviorSubject<String>? get selectedTimeOfDay => _selectedTimeOfDayStream;

  BehaviorSubject<EntryError>? _errorStateStream;
  BehaviorSubject<EntryError>? get errorState => _errorStateStream;

  NewEntryBloc() {
    _selectedMedicineTypeStream =
    BehaviorSubject<MedicineType>.seeded(MedicineType.none);
    _selectedTimeOfDayStream = BehaviorSubject<String>.seeded('none');
    _selectedIntervalStream = BehaviorSubject<int>.seeded(0);
    _errorStateStream = BehaviorSubject<EntryError>();
  }

  void dispose() {
    _selectedMedicineTypeStream!.close();
    _selectedTimeOfDayStream!.close();
    _selectedIntervalStream!.close();
    _errorStateStream!.close();
  }

  void submitError(EntryError error) {
    _errorStateStream!.add(error);
  }

  void updateInterval(int interval) {
    _selectedIntervalStream!.add(interval);
  }

  void updateTime(String time) {
    _selectedTimeOfDayStream!.add(time);
  }

  void updateSelectedMedicine(MedicineType type) {
    MedicineType _tempType = _selectedMedicineTypeStream!.value;
    if (type == _tempType) {
      _selectedMedicineTypeStream!.add(MedicineType.none);
    } else {
      _selectedMedicineTypeStream!.add(type);
    }
  }
}
