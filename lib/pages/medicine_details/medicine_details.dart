import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../global_bloc.dart';
import '../../models/medicine.dart';
import 'package:provider/provider.dart';
import '../Page1/constants.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails(this.medicine, {super.key});
  final Medicine medicine;

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Details',
          style: GoogleFonts.roboto(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: (true),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            MainSection(medicine: widget.medicine),
            SizedBox(height: 10),
            ExtendedSection(medicine: widget.medicine),
            Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: kSecondColor,
                  shape: const StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15)),
              onPressed: () {
                //open alert box
                openAlertBox(context, _globalBloc);
              },
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }

  openAlertBox(BuildContext context, GlobalBloc _globalBloc) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kSecondColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 1),
          title: Text('Delete This Reminder ?', style: TextStyle()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            TextButton(
              onPressed: () {
                //global bloc to delete Medicine
                _globalBloc.removeMedicine(widget.medicine);
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text(
                'OK',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: kErrorColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MainSection extends StatelessWidget {
  const MainSection({super.key, this.medicine});
  final Medicine? medicine;

  Hero makeIcon(double size) {
    if (medicine != null && medicine!.medicineType == 'pill') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/pill.svg',
          height:50,
          width: 50,
          color: kPurple,
        ),
      );
    } else if (medicine != null && medicine!.medicineType == 'insulin') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/insulin.svg',
          height: 50,
          width: 50,
          color: kPurple,
        ),
      );
    }
    // for condition of no medicine type icon selected
    return Hero(
      tag: medicine != null ? medicine!.medicineName! + medicine!.medicineType! : '',
      child: Icon(
        Icons.error,
        color: kErrorColor,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        makeIcon(50),
        SizedBox(height: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: medicine != null ? medicine!.medicineName! : '',
              child: Material(
                color: Colors.transparent,
                child: MainInfoTab(
                    fieldTitle: 'Medicine Name',
                    fieldInfo: medicine != null ? medicine!.medicineName! : ''),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            MainInfoTab(
                fieldTitle: 'Dosage',
                fieldInfo: medicine != null && medicine!.dosage != null && medicine!.dosage! > 0
                    ? '${medicine!.dosage} mg'
                    : 'Not Specified'),
          ],
        ),
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  const MainInfoTab({super.key, required this.fieldTitle, required this.fieldInfo});

  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          fieldTitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 0.5,
        ),
        Text(
          fieldInfo,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  const ExtendedInfoTab({super.key, required this.fieldTitle, required this.fieldInfo});
  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            fieldTitle,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: kTexColor,
            ),
          ),
          Text(
            fieldInfo,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: kOrange,
            ),
          ),
        ],
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  const ExtendedSection({super.key, this.medicine});

  final Medicine? medicine;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(
          fieldTitle: 'Medicine Type',
          fieldInfo: medicine != null && medicine!.medicineType != null &&
              medicine!.medicineType! != 'none'
              ? medicine!.medicineType!
              : 'Not Specified',
        ),
        ExtendedInfoTab(
          fieldTitle: 'Dosage Interval',
          fieldInfo: medicine != null && medicine!.interval != null
              ? 'Every ${medicine!.interval} Hours | ${medicine!.interval == 24
              ? 'One time a day'
              : '${(24 / medicine!.interval!).floor()} times a day'}'
              : 'Not Specified',
        ),
        ExtendedInfoTab(
          fieldTitle: 'Start Time',
          fieldInfo: medicine != null && medicine!.startTime != null &&
              medicine!.startTime!.isNotEmpty
              ? '${medicine!.startTime![0]}${medicine!
              .startTime![1]}:${medicine!.startTime![2]}${medicine!
              .startTime![3]}'
              : 'Not Specified',
        ),
      ],
    );
  }
}