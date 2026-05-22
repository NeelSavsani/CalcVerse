import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

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

      title: 'Calculator App',

      // LIGHT THEME
      theme: ThemeData(

        brightness: Brightness.light,

        scaffoldBackgroundColor:
        Colors.white,

        primaryColor: Colors.orange,

        fontFamily: 'Roboto',

        splashColor: Colors.transparent,

        highlightColor: Colors.transparent,

        appBarTheme: const AppBarTheme(

          elevation: 0,

          backgroundColor: Colors.white,

          foregroundColor: Colors.black,
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

        highlightColor: Colors.transparent,

        appBarTheme: const AppBarTheme(

          elevation: 0,

          backgroundColor:
          Color(0xFF0D1326),

          foregroundColor: Colors.white,
        ),
      ),

      themeMode:
      isDark
          ? ThemeMode.dark
          : ThemeMode.light,

      home: HomeScreen(

        isDark: isDark,

        toggleTheme: toggleTheme,
      ),
    );
  }
}