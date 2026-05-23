import 'package:flutter/material.dart';

import 'screens/data_screen.dart';
import 'screens/emi_screen.dart';
import 'screens/geo_screen.dart';
import 'screens/gst_screen.dart';
import 'screens/home_screen.dart';
import 'screens/temperature_screen.dart';
import 'screens/trigo_screen.dart';

import 'widgets/app_drawer.dart';

void main() {

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {

  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() =>
      _MyAppState();
}

class _MyAppState
    extends State<MyApp> {

  bool isDark = true;

  void toggleTheme() {

    setState(() {

      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'CalcVerse',

      // LIGHT THEME

      theme: ThemeData(

        brightness: Brightness.light,

        scaffoldBackgroundColor:
        Colors.white,

        primaryColor: Colors.orange,

        fontFamily: 'Roboto',

        splashColor: Colors.transparent,

        highlightColor:
        Colors.transparent,

        appBarTheme:
        const AppBarTheme(

          elevation: 0,

          backgroundColor:
          Colors.white,

          foregroundColor:
          Colors.black,
        ),
      ),

      // DARK THEME

      darkTheme: ThemeData(

        brightness: Brightness.dark,

        scaffoldBackgroundColor:
        const Color(0xFF0D1326),

        primaryColor: Colors.orange,

        fontFamily: 'Roboto',

        splashColor: Colors.transparent,

        highlightColor:
        Colors.transparent,

        appBarTheme:
        const AppBarTheme(

          elevation: 0,

          backgroundColor:
          Color(0xFF0D1326),

          foregroundColor:
          Colors.white,
        ),
      ),

      themeMode:
      isDark
          ? ThemeMode.dark
          : ThemeMode.light,

      initialRoute:
      AppDrawer.basicCalculatorRoute,

      routes: {

        // BASIC CALCULATOR

        AppDrawer
            .basicCalculatorRoute:

            (_) => HomeScreen(

          isDark: isDark,

          toggleTheme:
          toggleTheme,
        ),

        // TRIGONOMETRY

        AppDrawer
            .trigonometryRoute:

            (_) => TrigoScreen(

          isDark: isDark,

          toggleTheme:
          toggleTheme,
        ),

        // GEOMETRY

        AppDrawer
            .geometryRoute:

            (_) => GeoScreen(

          isDark: isDark,

          toggleTheme:
          toggleTheme,
        ),

        // EMI

        AppDrawer.emiRoute:

            (_) => EmiScreen(

          isDark: isDark,

          toggleTheme:
          toggleTheme,
        ),

        // GST

        AppDrawer.gstRoute:

            (_) => GstScreen(

          isDark: isDark,

          toggleTheme:
          toggleTheme,
        ),

        // DATA CONVERTER

        AppDrawer.dataRoute:

            (_) => DataScreen(

          isDark: isDark,

          toggleTheme:
          toggleTheme,
        ),

        // TEMPERATURE CONVERTER

        AppDrawer.temperatureRoute:

            (_) => TemperatureScreen(

          isDark: isDark,

          toggleTheme:
          toggleTheme,
        ),
      },
    );
  }
}