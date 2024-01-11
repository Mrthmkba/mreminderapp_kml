import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mreminderapp/global_bloc.dart';
import 'package:mreminderapp/models/medicine.dart';
import 'package:mreminderapp/pages/Page1/constants.dart';
import 'package:mreminderapp/pages/medicine_details/medicine_details.dart';
import 'package:mreminderapp/pages/new_entry/new_entry_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        onTap: () {
          //going to new page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const NewEntryPage(title: 'Add New', isRequired: true),
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
              child: Text(
                !snapshot.hasData ? '0' : snapshot.data!.length.toString(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
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
    //return Center(
    //child: Text(

    //'No Medicine',
    //style: GoogleFonts.roboto(
    //fontSize: 26,
    //color: Colors.orange,
    //fontWeight: FontWeight.w700,
    //)

    //),
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
          return GridView.builder(
            padding: EdgeInsets.only(top: 1),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return MedicineCard(
                  medicine: snapshot.data![index]);
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
  //get current details of saved item
  Hero makeIcon(double size) {
    String tag = '${medicine.medicineName!}_${medicine.medicineType!}';
    if (medicine.medicineType == 'Pill') {
      return Hero(
        tag: tag,
        child: SvgPicture.asset(
          'assets/icons/pill.svg',
          height: 7,
        ),
      );
    } else if (medicine.medicineType == 'Insulin') {
      return Hero(
        tag: tag,
        child: SvgPicture.asset(
          'assets/icons/insulin.svg',
          height: 7,
        ),
      );
    }
    // for condition of no medicine type icon selected
    return Hero(
      tag: tag,
      child: Icon(
        Icons.error,
        color: kTexColor,
        size: size,
      ),
    );
  }


  // Hero makeIcon(double size) {
  //   if (medicine.medicineType == 'Pill') {
  //     return Hero(
  //       tag: medicine.medicineName! + medicine.medicineType!,
  //       child: SvgPicture.asset(
  //         'assets/icons/pill.svg',
  //         color: kTexColor,
  //         height: 15,),
  //     );
  //   } else if (medicine.medicineType == 'Insulin') {
  //     return Hero(
  //       tag: medicine.medicineName! + medicine.medicineType!,
  //       child: SvgPicture.asset(
  //         'assets/icons/insulin.svg',
  //         color: kTexColor,
  //         height: 15,),
  //     );
  //   }
  //   // for condition of no medicine type icon selected
  //   return Hero(
  //     tag: medicine.medicineName! + medicine.medicineType!,
  //     child: Icon(
  //       Icons.error,
  //       color: kTexColor,
  //       size: size,
  //     ),
  //   );
  // }

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
        padding: EdgeInsets.only(left: 2,right: 2,top: 1,bottom: 1),
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: kSecondColor,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // calling make icon function
            const Spacer(),
            makeIcon(7),
            const Spacer(),
            // Tag animation
            Hero(
              tag: medicine.medicineName!,
              child: Text(
                medicine.medicineName!,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(height: 0.3),
        Text(
                medicine.interval == 1
                    ? 'Every ${medicine.interval} hour'
                    : 'Every ${medicine.interval} hours',
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleSmall,
              ),
          ],
        ),
      ),
    );
  }
}
