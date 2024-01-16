import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mreminderapp/Reminder/global_bloc.dart';
import 'package:mreminderapp/Reminder/models/medicine.dart';
import 'package:mreminderapp/Reminder/pages/Page1/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mreminderapp/models/medicine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../global_bloc.dart';
import '../medicine_details/medicine_details.dart';
import '../new_entry/new_entry_page.dart';
import 'constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reminder',
          style: GoogleFonts.roboto(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            TopContainer(),
            SizedBox(
              height: 2.0,
            ),
            //widget take place if needed
            Flexible(
              child: BottomContainer(),
            ),
          ],
        ),
      ),
      floatingActionButton: InkResponse(
        onTap: () async {
          // Call requestNotificationPermission when the button is pressed
          await requestNotificationPermission();

          // Going to new page
          Navigator.of(context).push(
            PageRouteBuilder<void>(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, Widget? child) {
                    return Opacity(
                      opacity: animation.value,
                      child: NewEntryPage(title: 'Add New', isRequired: true,),
                    );
                  },
                );
              },
              transitionDuration: const Duration(milliseconds: 600),
            ),
          );
        },
        child: const Card(
          color: kPurple,
          shape: CircleBorder(),
          child: Icon(
            Icons.add_outlined,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    );
  }
}

Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.status;

  if (status.isDenied) {
    await Permission.notification.request();
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /* Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            'Your Health  Your Wealth.',
            style:GoogleFonts.roboto(
              fontStyle: FontStyle.italic,
              color: Colors.cyan,
              fontSize: 28,
              fontWeight: FontWeight.w800,

            ),
          ),

        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 5),
          child:Text(
            'Welcome to Daily Health Reminder.',

            style:GoogleFonts.roboto(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w800,

            ),
          ),
        ),
*/
        SizedBox(
          height: 2,
        ),

        StreamBuilder<List<Medicine>>(
          stream: globalBloc.medicineList$,
          builder: (context, snapshot) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 1),
            );
          },
        ),
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return StreamBuilder(
      stream: globalBloc.medicineList$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          //no data saved
          return Container();
        } else if (snapshot.data!.isEmpty) {
          return Center(
            child: Text('No Medicine',
              style: GoogleFonts.roboto(
                fontSize: 24,
                color: Colors.orange,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.only(top: 1),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return MedicineCard(
                medicine: snapshot.data![index],
              );
            },
          );
        }
      },
    );
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({Key? key, required this.medicine}) : super(key: key);
  final Medicine medicine;

  Hero makeIcon(double size) {
    if (medicine.medicineType == 'pill') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/pill.svg',
          height: 50,
          width: 50,
        ),
      );
    } else if (medicine.medicineType == 'insulin') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/insulin.svg',
          height: 50,
          width: 50,
        ),
      );
    }
    // for condition of no medicine type icon selected
    return Hero(
      tag: medicine.medicineName! + medicine.medicineType!,
      child: Icon(
        Icons.error,
        color: kTexColor,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.grey,
      onTap: () {
        // Go to details
        Navigator.of(context).push(
          PageRouteBuilder<void>(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, Widget? child) {
                  return Opacity(
                    opacity: animation.value,
                    child: MedicineDetails(medicine),
                  );
                },
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
        height: 80, // Set a consistent height for each card
        padding: EdgeInsets.all(8), // Add padding for spacing
        margin: EdgeInsets.all(8), // Add margin for spacing
        decoration: BoxDecoration(
          color: kSecondColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            makeIcon(50),
            SizedBox(width: 16), // Adjust spacing between icon and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: medicine.medicineName!,
                    child: Text(
                      medicine.medicineName ?? '',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(height: 0.3),
                  Text(
                    medicine.interval != null
                        ? (medicine.interval == 1
                        ? 'Every ${medicine.interval} hour'
                        : 'Every ${medicine.interval} hours')
                        : 'Interval not specified',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
