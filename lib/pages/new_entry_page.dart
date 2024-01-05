// TODO Implement this library.

import 'dart:convert';
import 'dart:js_util';
import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'package:mreminderapp/models/errors.dart';
import 'package:provider/provider.dart';
import 'package:mreminderapp/models/medicine_type.dart';
import 'package:mreminderapp/pages/Page1/constants.dart';
import 'package:mreminderapp/pages/Page1/new_entry_bloc.dart';


import '../common/common.dart';


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
  }

  @override
  Widget build(BuildContext context) {
   // final GlobalBloc globalBloc= Provider.of<GlobalBloc>(context);
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
          padding: const EdgeInsets.all(2.0),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MedicineTypeColumn(
                            medicineType: MedicineType.pill,
                            name: "Pill",
                            iconValue: 'assets/icons/pill.png',
                            isSelected: snapshot.data == MedicineType.pill
                                ? true
                                : false),
                        SizedBox(
                          width: 22,
                        ),
                        MedicineTypeColumn(
                            medicineType: MedicineType.insulin,
                            name: "Insulin",
                            iconValue: 'assets/icons/insulin.png',
                            isSelected: snapshot.data == MedicineType.insulin
                                ? true
                                : false),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  PanelTitle(title: 'Interval Selection', isRequired: true),
                  SizedBox(
                    width: 26,
                  ),
                  PanelTitle(title: 'Start Time', isRequired: true),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              IntervalSelection(),
              SizedBox(
                height: 15,
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
                            padding: EdgeInsets.symmetric(horizontal: 45,vertical: 15)
                        ),
                        child: Center(
                            child: Text('Add',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  color: Colors.black,

                                ))),
                        onPressed: () {},
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  List<int> makeIDs(double n ){
    var rng = Random();
    List<int> ids = [];
    for(int i=0; i < n; i++){
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
  String selectedInterval = "Every 0 Hours";
  TimeOfDay selectedTime = TimeOfDay.now(); // Initialize with current time

  List<String> intervalOptions = [
    'Every 0 Hours',
    'Every 2 Hours',
    'Every 4 Hours',
    'Every 6 Hours',
    'Every 8 Hours',
    'Every 10 Hours',
  ];

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
    return Padding(
      padding: EdgeInsets.only(top: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownButton<String>(
            iconEnabledColor: kScaffoldColor,
            dropdownColor: Colors.grey[100],
            elevation: 0,
            value: selectedInterval,
            onChanged: (String? newValue) {
              setState(() {
                selectedInterval = newValue!;
              });
            },
            items: intervalOptions.map(
              (String interval) {
                return DropdownMenuItem<String>(
                  value: interval,
                  child: Text(interval),
                );
              },
            ).toList(),
          ),
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
                color: isSelected ? kOtherColor : Colors.blue,
                borderRadius: BorderRadius.circular(40),
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
