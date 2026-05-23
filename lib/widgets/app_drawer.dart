import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {

  // ROUTES

  static const String
  basicCalculatorRoute = '/';

  static const String
  trigonometryRoute =
      '/trigonometry';

  static const String
  geometryRoute =
      '/geometry';

  static const String
  emiRoute = '/emi';

  static const String
  gstRoute = '/gst';

  static const String
  dataRoute = '/data';

  static const String
  temperatureRoute =
      '/temperature';

  static const String
  unitRoute = '/unit';

  static const String
  ageRoute = '/age';


  static const String
  bmiRoute = '/bmi';

  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.currentRoute,
  });

  // OPEN ROUTE

  void openRoute(

      BuildContext context,

      String routeName,
      ) {

    Navigator.pop(context);

    if (currentRoute ==
        routeName) {

      return;
    }

    Navigator.pushReplacementNamed(

      context,

      routeName,
    );
  }

  // DRAWER TILE

  Widget drawerTile({

    required BuildContext context,

    required IconData icon,

    required String title,

    required String routeName,
  }) {

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final bool isActive =
        currentRoute ==
            routeName;

    final Color primaryText =
    isDark
        ? Colors.white
        : Colors.black;

    return Container(

      color:
      isActive

          ? isDark

          ? const Color(
          0xFF1A2238)

          : Colors.grey.shade200

          : Colors.transparent,

      child: ListTile(

        leading: Icon(

          icon,

          color: Colors.orange,
        ),

        title: Text(

          title,

          style: TextStyle(

            fontSize:
            isActive
                ? 18
                : 17,

            fontWeight:
            isActive

                ? FontWeight.w600

                : FontWeight.w500,

            color:
            primaryText,
          ),
        ),

        onTap: () {

          openRoute(

            context,

            routeName,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final Color backgroundColor =
    isDark
        ? const Color(0xFF0D1326)
        : Colors.white;

    final Color primaryText =
    isDark
        ? Colors.white
        : Colors.black;

    return Drawer(

      backgroundColor:
      backgroundColor,

      child: SafeArea(

        child: SingleChildScrollView(

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 40),

              // TITLE

              Padding(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 24,
                ),

                child: Text(

                  'CalcVerse',

                  style: TextStyle(

                    fontSize: 28,

                    fontWeight:
                    FontWeight.bold,

                    color:
                    primaryText,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // BASIC CALCULATOR

              drawerTile(

                context: context,

                icon:
                Icons.calculate,

                title:
                'Basic Calculator',

                routeName:
                basicCalculatorRoute,
              ),

              // TRIGONOMETRY

              drawerTile(

                context: context,

                icon:
                Icons.functions,

                title:
                'Trigonometry',

                routeName:
                trigonometryRoute,
              ),

              // GEOMETRY

              drawerTile(

                context: context,

                icon:
                Icons.hexagon_outlined,

                title:
                'Geometry',

                routeName:
                geometryRoute,
              ),

              // EMI CALCULATOR

              drawerTile(

                context: context,

                icon:
                Icons.currency_rupee,

                title:
                'EMI Calculator',

                routeName:
                emiRoute,
              ),

              // GST CALCULATOR

              drawerTile(

                context: context,

                icon:
                Icons.receipt_long,

                title:
                'GST Calculator',

                routeName:
                gstRoute,
              ),

              // DATA CONVERTER

              drawerTile(

                context: context,

                icon:
                Icons.storage,

                title:
                'Data Converter',

                routeName:
                dataRoute,
              ),

              // TEMPERATURE CONVERTER

              drawerTile(

                context: context,

                icon:
                Icons.thermostat,

                title:
                'Temperature Converter',

                routeName:
                temperatureRoute,
              ),

              //UNIT CONVERTER

              drawerTile(

                context: context,

                icon:
                Icons.straighten,

                title:
                'Unit Converter',

                routeName:
                unitRoute,
              ),

              //AGE CALCULATOR

              drawerTile(

                context: context,

                icon:
                Icons.cake,

                title:
                'Age Calculator',

                routeName:
                ageRoute,
              ),

            // BMI CALCLATOR
              drawerTile(

                context: context,

                icon:
                Icons.monitor_weight,

                title:
                'BMI Calculator',

                routeName:
                bmiRoute,
              ),
            ],
          ),
        ),
      ),
    );
  }
}