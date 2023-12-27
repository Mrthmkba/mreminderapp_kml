// TODO Implement this library.

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:mreminderapp/models/medicine_type.dart';
import 'package:mreminderapp/pages/Page1/constants.dart';

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();

    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Add New',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PanelTitle(
              title: 'Medicine Name',
              isRequired: true,
            ),
            TextFormField(
              maxLength: 15,
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(border: UnderlineInputBorder()),
            ),
            const PanelTitle(
              title: 'Dosage in (mg)',
              isRequired: false,
            ),
            TextFormField(
              controller: dosageController,
              maxLength: 5,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(border: UnderlineInputBorder()),
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
              child: StreamBuilder(
                //new entry block
                //stream:,
                builder: (context, snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MedicineTypeColumn(
                          medicineType: MedicineType.bottle,
                          name: "Bottle",
                          iconValue: 'assets/icons/pill (3).svg',
                          isSelected: snapshot.data == MedicineType.bottle
                              ? true
                              : false),
                      MedicineTypeColumn(
                          medicineType: MedicineType.pill,
                          name: "Pill",
                          iconValue: 'assets/icons/pill (3).svg',
                          isSelected: snapshot.data == MedicineType.pill
                              ? true
                              : false),
                      MedicineTypeColumn(
                          medicineType: MedicineType.syringe,
                          name: "Syringe",
                          iconValue: 'assets/icons/pill (3).svg',
                          isSelected: snapshot.data == MedicineType.syringe
                              ? true
                              : false),
                      MedicineTypeColumn(
                          medicineType: MedicineType.tablet,
                          name: "Tablet",
                          iconValue: 'assets/icons/pill (3).svg',
                          isSelected: snapshot.data == MedicineType.tablet
                              ? true
                              : false),
                    ],
                  );
                },
                stream: null,
              ),
            ),
            const PanelTitle(title: 'Interval Selection', isRequired: true),
             IntervalSelection(),
          ],
        ),
      ),
    );
  }
}

class IntervalSelection extends StatefulWidget {
  @override
  _IntervalSelectionState createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  String selectedInterval = "Every 2 Hours";

  List<String> intervalOptions =[
    'Every 2 Hours',
    'Every 4 Hours',
    'Every 6 Hours',
    'Every 8 Hours',
    'Every 10 Hours',

  ];
  @override
  Widget build(BuildContext context) {
   // final _intervals = [intervalOptions];
    //var _selected;
    return Padding(
      padding: EdgeInsets.all( 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remind Every',
            style:TextStyle(
              fontSize: 14,
            ),
          ),

          DropdownButton<String>(
            iconEnabledColor: kOtherColor,
            dropdownColor: kScaffoldColor,

            //itemHeight: 1,
            //hint: _selected == 0? Text('Select an Interval',
           // style: Theme.of(context).textTheme.titleSmall,):null,
            elevation: 2,
            //value: _selected== 0 ? null : _selected,
            value: selectedInterval,
            onChanged: (String? newValue){
              setState((){
                selectedInterval = newValue!;
              });
            },
            items: intervalOptions.map(
              (String interval) {
                return DropdownMenuItem<String>(
                  value: interval,
                  child: Text( interval),
                );
              }).toList(),
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
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 100,
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: isSelected ? kOtherColor : Colors.white),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: 5,
                ),
                child: SvgPicture.asset(
                  iconValue,
                  height: 60,
                  color: isSelected ? Colors.white : kOtherColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Container(
              width: 60,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? kOtherColor : Colors.transparent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                  child: Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: isSelected ? Colors.white : kOtherColor),
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
