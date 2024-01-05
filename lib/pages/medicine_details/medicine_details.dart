import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Page1/constants.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails({super.key});

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          MainSection(),
          SizedBox(
            height: 10,
          ),
          ExtendedSection(),
          Spacer(),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: kSecondColor,
                shape: const StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15)),
            onPressed: () {
              //open alert box
              openAlertBox(context);
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
    );
  }

  openAlertBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kSecondColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft:Radius.circular(20),
            bottomRight: Radius.circular(20),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 1),
          title: Text(
            'Delete This Reminder ?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text(
                'Cencel',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            TextButton(
              onPressed: (){
                //global bloc to delete Medicine
              },
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: kErrorColor),
              ),
            ),
          ],

        );
      },
    );
  }
}

class MainSection extends StatelessWidget {
  const MainSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'assets/icons/pill.png',
          height: 20,
        ),
        const Column(
          // mainAxisAlignment: MainAxisAlignment.center,

          children: [
            SizedBox(height: 10,),
            MainInfoTab(
              fieldTitle: 'Medicine Name',
              fieldInfo: 'Pill',
            ),
            SizedBox(height: 8,),
            MainInfoTab(
              fieldTitle: 'Dosage',
              fieldInfo: '500 mg',
            ),
          ],
        ),
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  const MainInfoTab(
      {super.key, required this.fieldTitle, required this.fieldInfo});

  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
  const ExtendedInfoTab(
      {super.key, required this.fieldTitle, required this.fieldInfo});
  final String fieldTitle;
  final String fieldInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 25),
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
  const ExtendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: const [
        ExtendedInfoTab(
          fieldTitle: 'Medicine Type',
          fieldInfo: 'Pill',
        ),
        ExtendedInfoTab(
          fieldTitle: 'Dosage Interval',
          fieldInfo: 'Every 8 Hours | 3 Times a day',
        ),
        ExtendedInfoTab(
          fieldTitle: 'Start Time',
          fieldInfo: '01:40',
        ),
      ],
    );
  }
}
