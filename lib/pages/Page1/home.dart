import 'package:flutter/material.dart';
import 'package:mreminderapp/pages/Page1/constants.dart';
import '../new_entry_page.dart';
import 'package:google_fonts/google_fonts.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Daily Reminder...',
          style: GoogleFonts.roboto(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),

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

          child: Card(

            color: kPrimaryColor,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.add_outlined,
              color: kTexColor,
              size: 40,
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
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            'Your Health , Your Wealth.',
            style:GoogleFonts.roboto(
              fontStyle: FontStyle.italic,
              color: Colors.brown,
              fontSize: 28,
              fontWeight: FontWeight.w800,

            ),
          ),
        ),

        const SizedBox(
          height: 5,
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 2),
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
    return Center(
      child: Text(

        'No Medicine',
        style: GoogleFonts.roboto(
          fontSize: 26,
          color: Colors.orange,
            fontWeight: FontWeight.w700,
        )


      ),
    );
  }
}
