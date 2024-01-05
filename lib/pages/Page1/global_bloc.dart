

import 'package:mreminderapp/models/medicine.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class GlobalBloc{
  BehaviorSubject<List<Medicine>>? _medicineList$;
  BehaviorSubject<List<Medicine>>? get medicineList$ => _medicineList$;

  GlobalBloc(){
    _medicineList$ = BehaviorSubject<List<Medicine>>.seeded([]);
    makeMedicineList();

  }

  //Future UpdateMedicineLit(Medicine newMedicine) asynce

  Future makeMedicineList() async {
    SharedPreferences? sharedUser = await SharedPreferences.getInstance();
    List<String>? jsonList = sharedUser.getStringList('medicines');
    List<Medicine> prefList= [];

    if ( jsonList == null){
      return;
    }else {
      for(String jsonMedicine in jsonList){
        dynamic userMap = jsonDecode(jsonMedicine);
        Medicine tempMedicine = Medicine.fromJson(userMap);
        prefList.add(tempMedicine);
      }

      //update list
      _medicineList$!.add(prefList);
    }
  }

  void dispose(){
    _medicineList$!.close();
  }
}
