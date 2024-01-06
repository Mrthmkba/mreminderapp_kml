// TODO Implement this library.
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
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
  var _newEntryBloc = NewEntryBloc();

  late TimeOfDay selectedTime;

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
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 4,
              ),
              const PanelTitle(
                title: 'Medicine Name',
                isRequired: true,
              ),
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
                    )),
              ),
              const PanelTitle(
                title: 'Dosage in (mg)',
                isRequired: false,
              ),
              SizedBox(
                height: 2,
              ),
              TextFormField(
                controller: dosageController,
                maxLength: 5,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: kOtherColor,
                    border: UnderlineInputBorder()),
              ),
              SizedBox(
                height: 2.0,
              ),
              const PanelTitle(title: 'Medicine Type :-', isRequired: false),
              SizedBox(
                height: 2,
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0),
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
                        SizedBox(
                          width: 22,
                        ),
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
              const SizedBox(
                height: 2,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PanelTitle(title: 'Interval Selection', isRequired: true),
                  SizedBox(
                    width: 26,
                  ),
                  PanelTitle(title: 'Start Time', isRequired: true),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              IntervalSelection(),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 8,
                  right: 8,
                ),
                child: Center(
                  child: SizedBox(
                      width: 150,
                      height: 50,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: kSecondColor,
                            shape: const StadiumBorder(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 45, vertical: 15),
                        ),
                        child: Center(
                            child: Text('Add',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                            ),
                        ),
                        onPressed: () {
                          String? medicineName;
                          int? dosage;
                          if (nameController.text == "") {
                            _newEntryBloc.submiterror(EntryError.nameNull);
                            return;
                          }

                          if (nameController.text != "") {
                            medicineName = nameController.text;
                          }

                          if (dosageController.text == "") {
                            _newEntryBloc.submiterror(EntryError.dosage);
                            return;
                          }
                          if (dosageController.text != "") {
                            dosage = int.parse(dosageController.text);
                          }

                          for (var medicine in globalBloc.medicineList$!.value) {
                            if (medicineName == medicine.medicineName) {
                              _newEntryBloc.submiterror(EntryError.nameDuplicate);
                              return;
                            }
                          }
                          if (_newEntryBloc.selectedIntervals!.value == 0) {
                            _newEntryBloc.submiterror(EntryError.interval);
                            return;
                          }
                          if (_newEntryBloc.selectedTimeOfDay!.value == "None") {
                            _newEntryBloc.submiterror(EntryError.startTime);
                            return;
                          }

                          String medicineType = _newEntryBloc
                              .selectedMedicineType!.value
                              .toString()
                              .substring(13);

                          int interval = _newEntryBloc.selectedIntervals!.value;
                          String startTime =
                              _newEntryBloc.selectedTimeOfDay!.value;

                          List<int> intIDs = makeIDs(
                              24 / -_newEntryBloc.selectedIntervals!.value);
                          List<String> notificationIDs =
                              intIDs.map((i) => i.toString()).toList();

                          Medicine newEntryMedicine = Medicine(
                              notificationIDs: notificationIDs,
                              medicineName: medicineName,
                              dosage: dosage,
                              medicineType: medicineType,
                              interval: interval,
                              startTime: startTime);

                          globalBloc.UpdateMedicineList(newEntryMedicine);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessPage()));
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



  // void _showSuccessDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Success!',
  //           style: GoogleFonts.poppins(
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.green,
  //           ),
  //         ),
  //         content: Text(
  //           'Your medicine has been successfully scheduled.',
  //           style: GoogleFonts.poppins(
  //             fontSize: 18,
  //             color: Colors.black,
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Close the dialog
  //             },
  //             child: Text(
  //               'OK',
  //               style: GoogleFonts.poppins(
  //                 fontSize: 16,
  //                 color: kSecondColor,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void initializeErrorListen() {
    _newEntryBloc.errorState$!.listen((EntryError error) {
      switch (error) {
        case EntryError.nameNull:
          displayError("Please fill in the medicine's name");
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

  List<int> makeIDs(double n)  {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(100000));
    }
    return ids;
  }
}






class IntervalSelection extends StatefulWidget {
  const IntervalSelection({super.key});

  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  var selectedInterval = 0;
  TimeOfDay selectedTime = TimeOfDay.now() ;// Initialize with current time

  final intervalOptions = [0, 2, 4, 6, 8, 10, 12, 24];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Padding(
      padding: EdgeInsets.only(top: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<int>(
            iconEnabledColor: kScaffoldColor,
            dropdownColor: kOtherColor,
            elevation: 4,
            hint: selectedInterval == 0
                ? Text(
                    "Select Interval",
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                : null,
            value: selectedInterval == 0 ? null : selectedInterval,
            items: intervalOptions.map(
              (int interval) {
                return DropdownMenuItem<int>(
                  value: interval,
                  child: Text(interval.toString()),
                );
              },
            ).toList(),
            onChanged: (int? newValue) {
              setState(() {
                selectedInterval = newValue!;
                _newEntryBloc.updateInterval(newValue);
              });

            },
          ),
          Text(selectedInterval == 1 ? "Hour" : "Hours",
          style: Theme.of(context).textTheme.titleSmall,),

          const Icon(
            Icons.access_time,
            size: 50,
            color: kScaffoldColor,
          ),
          InkWell(
            onTap: () {
              _selectTime(context);
            },
            child: Text(
              selectedTime.format(context),
              style: TextStyle(
                fontSize: 12,
                color: kScaffoldColor,
              ),
            ),
          ),
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
      this.isSelected})
      : super(key: key);

  final MedicineType medicineType;
  final String name;
  final String iconValue;
  final isSelected;
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
                  top: 8,
                  bottom: 5,
                ),
                child: Image.asset(
                  iconValue,
                  height: 100,
                  color: isSelected ? Colors.black : kOtherColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? kOtherColor : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
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
