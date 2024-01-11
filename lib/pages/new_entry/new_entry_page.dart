// TODO Implement this library.
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:mreminderapp/common/convert_time.dart';
import 'package:mreminderapp/global_bloc.dart';
import 'package:mreminderapp/models/errors.dart';
import 'package:mreminderapp/models/medicine.dart';
import 'package:provider/provider.dart';
import 'package:mreminderapp/models/medicine_type.dart';
import 'package:mreminderapp/pages/Page1/constants.dart';
import 'package:mreminderapp/pages/Page1/new_entry_bloc.dart';
//import 'package:flutter/time_picker.dart';
import 'package:mreminderapp/pages/SuccessScreen/SuccessScreen.dart';

class NewEntryPage extends StatefulWidget {
  const NewEntryPage(
      {super.key, required this.title, required this.isRequired});
  final String title;
  final bool isRequired;

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late NewEntryBloc _newEntryBloc;
  late TimeOfDay selectedTime;
  int? dosage = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _newEntryBloc = NewEntryBloc();
    initializeErrorListen();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Add Reminder',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Provider<NewEntryBloc>.value(
        value: _newEntryBloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PanelTitle(
                title: 'Medicine Name',
                isRequired: true,
              ),
              SizedBox(height: 2),
              TextFormField(
                maxLength: 15,
                controller: nameController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: kOtherColor,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 2),
              const PanelTitle(
                title: 'Dosage in (mg)',
                isRequired: false,
              ),
              TextFormField(
                controller: dosageController,
                maxLength: 5,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: kOtherColor,
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 2),
              const PanelTitle(title: 'Medicine Type :-', isRequired: false),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: StreamBuilder<MedicineType>(
                  //new entry block
                  stream: _newEntryBloc.selectedMedicineType,
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MedicineTypeColumn(
                            medicineType: MedicineType.pill,
                            name: "Pill",
                            iconValue: 'assets/icons/pill.svg',
                            isSelected: snapshot.data == MedicineType.pill
                                ? true
                                : false),
                        const SizedBox(width: 22),
                        MedicineTypeColumn(
                            medicineType: MedicineType.insulin,
                            name: "Insulin",
                            iconValue: 'assets/icons/insulin.svg',
                            isSelected: snapshot.data == MedicineType.insulin
                                ? true
                                : false),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 2),
              const PanelTitle(title: 'Interval Selection', isRequired: true),
              const IntervalSelection(),
              const SizedBox(height: 2),
              const PanelTitle(title: ' Starting Time', isRequired: true),
              const SelectTime(),
              const SizedBox(
                height: 4,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: SizedBox(
                    height: 30,
                    width: 180,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: kSecondColor,
                          shape: const StadiumBorder(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 45, vertical: 15)),
                      child: Center(
                        child: Text(
                          'Save',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: kTexColor,
                                  ),
                        ),
                      ),
                      onPressed: () {
                        String? medicineName;
                        int? dosage;
                        if (nameController.text.isEmpty) {
                          _newEntryBloc.submitError(EntryError.nameNull);
                          return;
                        }

                        if (nameController.text.isNotEmpty) {
                          medicineName = nameController.text;
                        }

                        if (dosageController.text.isEmpty) {
                          _newEntryBloc.submitError(EntryError.dosage);
                          return;
                        }
                        if (dosageController.text.isNotEmpty) {
                          dosage = int.parse(dosageController.text);
                        }

                        for (var medicine in globalBloc.medicineList$!.value) {
                          if (medicineName == medicine.medicineName) {
                            _newEntryBloc.submitError(EntryError.nameDuplicate);
                            return;
                          }
                        }
                        if (_newEntryBloc.selectedInterval!.value == 0) {
                          _newEntryBloc.submitError(EntryError.interval);
                          return;
                        }
                        if (_newEntryBloc.selectedTimeOfDay!.value == "None") {
                          _newEntryBloc.submitError(EntryError.startTime);
                          return;
                        }

                        String medicineType = _newEntryBloc
                            .selectedMedicineType!.value
                            .toString()
                            .substring(10);

                        int interval = _newEntryBloc.selectedInterval!.value;
                        String startTime =
                            _newEntryBloc.selectedTimeOfDay!.value;

                        List<int> intIDs =
                            makeIDs(24 / _newEntryBloc.selectedInterval!.value);
                        List<String> notificationIDs =
                            intIDs.map((i) => i.toString()).toList();

                        Medicine newEntryMedicine = Medicine(
                            notificationIDs: notificationIDs,
                            medicineName: medicineName,
                            dosage: dosage,
                            medicineType: medicineType,
                            interval: interval,
                            startTime: startTime);

                        //updating medicineList using global bloc
                        globalBloc.updateMedicineList(newEntryMedicine);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:(context)=> SuccessPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void initializeErrorListen() {
    _newEntryBloc.errorState!.listen((EntryError error) {
      switch (error) {
        case EntryError.nameNull:
          displayError(
            "Please fill in the medicine's name",
          );
          break;

        case EntryError.nameDuplicate:
          //  Handle this case.
          displayError("This medicine been already scheduled");
          break;

        case EntryError.dosage:
          //  Handle this case.
          displayError("Please fill in the required dosage");
          break;

        case EntryError.type:
          // Handle this case.
          displayError("Please choose medicine type ");
          break;

        case EntryError.interval:
          //  Handle this case.
          displayError("Please select the medicine interval");
          break;

        case EntryError.startTime:
          //  Handle this case.
          displayError("Please select the starting time for schedule");
          break;
        default:
      }
    });
  }
  void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kSecondColor,
        content: Text(error),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }
}

class SelectTime extends StatefulWidget {
  const SelectTime({Key? key}) : super(key: key);

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = const TimeOfDay(hour: 0, minute: 0);
  bool _clicked = false;

  Future<TimeOfDay> _selectedTime() async {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context, listen:false);
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: _time);
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
        // Update state using provider or any other state management approach.
        newEntryBloc.updateTime(convertTime(_time.hour.toString()) + convertTime(_time.minute.toString()));

      });
    }
    return picked!;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 45,
        width: 200,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: kSecondColor,
            shape: const StadiumBorder(),
          ),
          onPressed: () async {
            await _selectedTime(); // Await the Future
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? 'Select Time'
                  : '${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}


//   void _showSuccessDialog() {
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         title: Text(
//   //           'Success!',
//   //           style: GoogleFonts.poppins(
//   //             fontSize: 24,
//   //             fontWeight: FontWeight.bold,
//   //             color: Colors.green,
//   //           ),
//   //         ),
//   //         content: Text(
//   //           'Your medicine has been successfully scheduled.',
//   //           style: GoogleFonts.poppins(
//   //             fontSize: 18,
//   //             color: Colors.black,
//   //           ),
//   //         ),
//   //         actions: [
//   //           TextButton(
//   //             onPressed: () {
//   //               Navigator.pop(context); // Close the dialog
//   //             },
//   //             child: Text(
//   //               'OK',
//   //               style: GoogleFonts.poppins(
//   //                 fontSize: 16,
//   //                 color: kSecondColor,
//   //               ),
//   //             ),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//

class IntervalSelection extends StatefulWidget {
  const IntervalSelection({Key? key}) : super(key: key);

  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _intervals = [1,2, 4, 6, 8, 10, 12,24];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Repeat Every',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: "Roboto Mono",
              fontWeight: FontWeight.w600,
            ),
          ),
          DropdownButton(
            iconEnabledColor: kScaffoldColor,
            dropdownColor: kSecondColor,
            hint: _selected == 0
                ? const Text(
              'Select Interval',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: "Roboto Mono",
                fontWeight: FontWeight.w500,
              ),
            )
                : null,
            elevation: 4,
            value: _selected == 0 ? null : _selected,
            items: _intervals.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              );
            }).toList(),
            onChanged: (newVal) {
              setState(() {
                _selected = newVal!;
                newEntryBloc.updateInterval(newVal);

              });
            },
          ),
          Text(
            _selected == 1 ? "Hour" : "Hours",
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}


class MedicineTypeColumn extends StatelessWidget {
  const MedicineTypeColumn(
      {Key? key,
      required this.medicineType,
      required this.name,
      required this.iconValue,
      required this.isSelected})
      : super(key: key);

  final MedicineType medicineType;
  final String name;
  final String iconValue;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return GestureDetector(
      onTap: () {
        newEntryBloc.updateSelectedMedicine(medicineType);
      },
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: isSelected ? kOtherColor : kSecondColor),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 1,
                  bottom: 2,
                ),
                child: SvgPicture.asset(
                  iconValue,
                  height: 85,
                  width: 85,
                  color: isSelected ? kSecondColor : kTexColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? kOtherColor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                  child: Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: isSelected ? Colors.purple : kTexColor),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  const PanelTitle({super.key, required this.title, required this.isRequired});
  final String title;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: "Roboto Mono",
                  fontWeight: FontWeight.w600,
                )),
            TextSpan(
                text: isRequired ? "*" : "",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.redAccent,
                ))
          ],
        ),
      ),
    );
  }
}