import 'dart:math';
import 'dart:core';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:mreminderapp/Reminder/common/convert_time.dart';
import 'package:mreminderapp/Reminder/global_bloc.dart';
import 'package:mreminderapp/Reminder/models/errors.dart';
import 'package:mreminderapp/Reminder/models/medicine.dart';
import 'package:mreminderapp/Reminder/pages/Page1/home.dart';
import 'package:provider/provider.dart';
import 'package:mreminderapp/Reminder/models/medicine_type.dart';
import 'package:mreminderapp/Reminder/pages/Page1/constants.dart';
import 'package:mreminderapp/Reminder/pages/Page1/new_entry_bloc.dart';
// import 'package:flutter/time_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mreminderapp/Reminder/pages/SuccessScreen/SuccessScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../common/convert_time.dart';
import '../../global_bloc.dart';
import '../../models/errors.dart';
import '../../models/medicine.dart';
import '../../models/medicine_type.dart';
import '../Page1/constants.dart';
import '../Page1/home.dart';
import '../Page1/new_entry_bloc.dart';
import '../SuccessScreen/SuccessScreen.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';


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
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
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
    flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _newEntryBloc = NewEntryBloc();
    initializeNotifications();
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
              TextField(
                maxLength: 15,
                controller: nameController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                textCapitalization: TextCapitalization.words,
                decoration:  InputDecoration(
                  filled: true,
                  fillColor: kSecondColor,
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(17),
                  //     color: isSelected ? kOtherColor : kSecondColor),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 2),
              const PanelTitle(
                title: 'Dosage in (mg)',
                isRequired: false,
              ),
              TextField(
                controller: dosageController,
                maxLength: 5,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: kSecondColor,
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
                height: 60,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: kSecondColor,
                        shape: const StadiumBorder(),
                      ),
                      child: Center(
                        child: Text(
                          'Add',
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
                            .substring(13);

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
                        scheduledNotification(newEntryMedicine);
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

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;

    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future onSelectNotification(String? payload) async {
    if(payload != null){
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(context, MaterialPageRoute(
        builder: (context)=> const HomePage(title: 'Reminder',)));
  }

  Future<void> scheduledNotification(Medicine medicine)async{
    var hour = int.parse(medicine.startTime![0]+medicine.startTime![1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime![2]+ medicine.startTime![3]);

    var androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
        'repeatDailyAtTime channel id','repeatDailyAtTime channel name',
        importance : Importance.max,
        ledColor: kSecondColor,
        ledOffMs: 1000,
        ledOnMs: 1000,
        enableLights: true);

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android : androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics
    );
    for (int i = 0; i < (24 / medicine.interval!).floor(); i++) {
      if (hour + (medicine.interval! * i) > 23) {
        hour = hour + (medicine.interval! * i) - 24;
      } else {
        hour = hour + (medicine.interval! * i);
      }
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        int.parse(medicine.notificationIDs![i]),
        'Reminder: ${medicine.medicineName}',
        medicine.medicineType.toString() !=
            MedicineType.none.toString()
            ? 'It is time to take your ${medicine.medicineType!
            .toLowerCase()}, according to schedule'
            : 'It is time to take your medicine, according to schedule',
        Time(hour, minute), // Adjust this line accordingly if minute is needed
        platformChannelSpecifics,
        payload: 'Notification Payload',
      );
      hour = ogValue;
    }

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
            focusColor: kTextLightColor,
            iconEnabledColor: kScaffoldColor,
            dropdownColor: kTextLightColor,
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
                  style: Theme.of(context).textTheme.bodySmall,
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
                borderRadius: BorderRadius.circular(17),
                color: isSelected ? kTexColor : kSecondColor),
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
                color: isSelected ? kTexColor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                  child: Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: isSelected ? kSecondColor : kTexColor),
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