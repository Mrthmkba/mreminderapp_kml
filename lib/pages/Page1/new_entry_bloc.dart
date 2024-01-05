import 'package:flutter/material.dart';
import 'package:mreminderapp/models/medicine_type.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/errors.dart';

class NewEntryBloc {
  BehaviorSubject<MedicineType>? _selectedMedicineType;

  ValueStream<MedicineType>? get selectedMedicineType => _selectedMedicineType!.stream;

  BehaviorSubject<int>? _selectedIntervals;

  BehaviorSubject<int>? get selectedIntervals => selectedIntervals;

  late BehaviorSubject<String>? selectedTimeOfDay;

  BehaviorSubject<String>? get _selectTimeOfDay$ => selectedTimeOfDay;


  //Error State
  BehaviorSubject<EntryError>? _errorState;

  BehaviorSubject<EntryError>? get errorState => _errorState;


  NewEntryBloc() {
    _selectedMedicineType =
    BehaviorSubject<MedicineType>.seeded(MedicineType.none);
    selectedTimeOfDay = BehaviorSubject<String>.seeded('none');
    _selectedIntervals = BehaviorSubject<int>.seeded(0);
    _errorState = BehaviorSubject<EntryError>();
  }

  void dispose() {
    _selectedMedicineType!.close();
    selectedTimeOfDay!.close();
    _selectedIntervals!.close();
  }

  void submiterror(EntryError error) {
    _errorState!.add(error);
  }

  void updateInterval(int interval) {
    _selectedIntervals!.add(interval);
  }

  void updateTime(String time) {
    selectedTimeOfDay!.add(time);
  }

  void updateSelectedMedicine(MedicineType type) {
    MedicineType _tempType = _selectedMedicineType!.value;
    if (type == _tempType) {
      _selectedMedicineType!.add(MedicineType.none);
    } else {
      _selectedMedicineType!.add(type);
    }
  }
}

