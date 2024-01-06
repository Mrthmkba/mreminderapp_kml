import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mreminderapp/pages/Page1/constants.dart';
import 'package:mreminderapp/pages/medicine_details/medicine_details.dart';
import '../new_entry_page.dart';
import 'package:google_fonts/google_fonts.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder',
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
              builder: (context) =>  const NewEntryPage(title: 'Add New', isRequired: true),),
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
          height: 10,
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 10,top: 10),
          child: Text(
            '0',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});
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
    return GridView.builder(
        padding: EdgeInsets.only(top: 1),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:3,
    ),
      itemCount :6,
      itemBuilder : (context,index){
      return MedicineCard();
      }
    );

  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({Key? key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.grey,
      onTap: () {
        // Go to details
        Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineDetails()));
      },
      child: Container(
        padding: EdgeInsets.all(2),
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: kSecondColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/pill.svg',
              height: 50, // Adjust the height as needed
              color: kOtherColor,
            ),
            const Spacer(),
            // Tag animation
            Text(
              'Pill',
              overflow: TextOverflow.fade,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 0.5),
            Text(
              'Every 8 Hours',
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