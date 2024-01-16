import 'package:flutter/material.dart';
import 'package:mreminderapp/pages/Page1/new_entry_bloc.dart';
import 'package:provider/provider.dart';
import 'global_bloc.dart';
import 'pages/Page1/constants.dart';
import 'pages/Page1/home.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalBloc? globalBloc;

  @override
  void initState() {
    // TODO: implement initState
    globalBloc = GlobalBloc();
    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
      value:globalBloc! ,
      child:MaterialApp(
      title: 'Medicine Reminder',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        //appbar theme
        appBarTheme: const AppBarTheme(

          backgroundColor: Colors.white,
          elevation: 10,
          iconTheme: IconThemeData(
            color: kSecondColor, size: 20,),

          //Icon Theme


        ),
        textTheme: TextTheme(
          headlineSmall: const TextStyle(
              fontSize: 20, color: kTexColor, fontWeight: FontWeight.w500),
          labelMedium: GoogleFonts.roboto(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),
          headlineMedium: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.w800, color: kTexColor,
          ),
          headlineLarge: const TextStyle(
            fontSize: 28, fontWeight: FontWeight.w800, color: kTexColor,

          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: kTexColor,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: kTexColor,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: kTexColor,
          ),



          titleSmall: GoogleFonts.poppins(fontSize: 14, color: kTexColor,fontWeight: FontWeight.w400),
          titleMedium: GoogleFonts.poppins(fontSize: 16, color: kTexColor),
          titleLarge: GoogleFonts.poppins(fontSize: 18, color: kTexColor,fontWeight: FontWeight.w600),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: kTextLightColor,
              width: 0.7,
            ),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: kTextLightColor,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: kPrimaryColor,
            ),
          ),
        ),
       //  timePickerTheme: TimePickerThemeData(
       //    backgroundColor: kSecondColor,
       //    hourMinuteColor: kTexColor,
       //    hourMinuteTextColor: kTexColor,
       //    dayPeriodColor: kSecondColor,
       //    dayPeriodTextColor: kTexColor,
       //    dialBackgroundColor: kSecondColor,
       //    dialHandColor: kSecondColor,
       //    dialTextColor: kTexColor,
       //    entryModeIconColor: kOtherColor,
       //    dayPeriodTextStyle: GoogleFonts.poppins(
       //      fontSize: 10,
       //    ),
       //
       // ),
      ),
      home: const HomePage(title:'Reminder'),
        debugShowCheckedModeBanner: false,
    ),
    );
  }
}