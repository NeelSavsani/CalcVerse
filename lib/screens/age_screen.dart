import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class AgeScreen extends StatefulWidget {

  final bool isDark;
  final VoidCallback toggleTheme;

  const AgeScreen({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<AgeScreen> createState() =>
      _AgeScreenState();
}

class _AgeScreenState
    extends State<AgeScreen> {

  final GlobalKey<ScaffoldState>
  scaffoldKey =
  GlobalKey<ScaffoldState>();

  DateTime? dob;

  DateTime? targetDate;

  bool showResult = false;

  List<List<String>> results = [];

  Future<void> pickDate(
      bool isDob,
      ) async {

    DateTime initialDate =
    DateTime.now();

    DateTime firstDate =
    DateTime(1900);

    DateTime lastDate =
    DateTime(2100);

    final DateTime? picked =
    await showDatePicker(

      context: context,

      initialDate:
      initialDate,

      firstDate:
      firstDate,

      lastDate:
      lastDate,
    );

    if (picked != null) {

      setState(() {

        if (isDob) {

          dob = picked;

        } else {

          targetDate = picked;
        }
      });
    }
  }

  void clearAll() {

    setState(() {

      dob = null;

      targetDate = null;

      showResult = false;

      results.clear();
    });
  }

  void calculateAge() {

    if (dob == null) {

      return;
    }

    DateTime target =
        targetDate ??
            DateTime.now();

    int years =
        target.year -
            dob!.year;

    int months =
        target.month -
            dob!.month;

    int days =
        target.day -
            dob!.day;

    if (days < 0) {

      months--;

      days += DateTime(

        target.year,

        target.month,

        0,
      ).day;
    }

    if (months < 0) {

      years--;

      months += 12;
    }

    int totalDays =
        target
            .difference(dob!)
            .inDays;

    int totalWeeks =
    (totalDays / 7)
        .floor();

    int totalMonths =
        years * 12 + months;

    int totalHours =
        totalDays * 24;

    DateTime nextBirthday =
    DateTime(

      target.year,

      dob!.month,

      dob!.day,
    );

    if (nextBirthday
        .isBefore(target)) {

      nextBirthday =
          DateTime(

            target.year + 1,

            dob!.month,

            dob!.day,
          );
    }

    int daysToBirthday =
        nextBirthday
            .difference(target)
            .inDays;

    setState(() {

      results = [

        [
          'Age',
          '$years yrs, $months mo, $days days'
        ],

        [
          'Total Days',
          totalDays
              .toString()
        ],

        [
          'Total Weeks',
          totalWeeks
              .toString()
        ],

        [
          'Total Months',
          totalMonths
              .toString()
        ],

        [
          'Total Hours',
          totalHours
              .toString()
        ],

        [
          'Days to Birthday',
          '$daysToBirthday days'
        ],
      ];

      showResult = true;
    });
  }

  Widget buildDateField({

    required String label,

    required String value,

    required VoidCallback onTap,

    required Color cardColor,

    required Color primaryText,

    required Color secondaryText,
  }) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(

          label,

          style: TextStyle(

            fontSize: 15,

            fontWeight:
            FontWeight.w500,

            color:
            secondaryText,
          ),
        ),

        const SizedBox(height: 8),

        GestureDetector(

          onTap: onTap,

          child: Container(

            width:
            double.infinity,

            padding:
            const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),

            decoration:
            BoxDecoration(

              color:
              cardColor,

              borderRadius:
              BorderRadius.circular(
                18,
              ),
            ),

            child: Text(

              value,

              style: TextStyle(

                color:
                value ==
                    'Select Date'

                    ? secondaryText

                    : primaryText,

                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final bool isDark =
        Theme.of(context)
            .brightness ==
            Brightness.dark;

    final Color bgColor =
    isDark
        ? const Color(
        0xFF0D1326)
        : Colors.white;

    final Color cardColor =
    isDark
        ? const Color(
        0xFF1A2238)
        : const Color(
        0xFFF4F4F4);

    final Color primaryText =
    isDark
        ? Colors.white
        : Colors.black;

    final Color secondaryText =
    isDark
        ? Colors.grey.shade400
        : Colors.grey.shade700;

    return Scaffold(

      key: scaffoldKey,

      backgroundColor:
      bgColor,

      drawer: const AppDrawer(
        currentRoute:
        AppDrawer.ageRoute,
      ),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
        bgColor,

        automaticallyImplyLeading:
        false,

        title: Row(

          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,

          children: [

            GestureDetector(

              onTap: () {

                scaffoldKey
                    .currentState
                    ?.openDrawer();
              },

              child: Icon(

                Icons.menu,

                color:
                primaryText,
              ),
            ),

            Text(

              "Age Calculator",

              style: TextStyle(

                color:
                primaryText,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            IconButton(

              onPressed: () {

                widget
                    .toggleTheme();

                Future.delayed(

                  const Duration(
                    milliseconds: 50,
                  ),

                      () {

                    if (mounted) {

                      setState(() {});
                    }
                  },
                );
              },

              icon: Icon(

                isDark
                    ? Icons.light_mode
                    : Icons.dark_mode,

                color:
                primaryText,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(

        child:
        SingleChildScrollView(

          padding:
          const EdgeInsets.all(
            20,
          ),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment
                .start,

            children: [

              buildDateField(

                label:
                "Date of Birth",

                value:
                dob == null

                    ? 'Select Date'

                    : '${dob!.day}/${dob!.month}/${dob!.year}',

                onTap: () {

                  pickDate(true);
                },

                cardColor:
                cardColor,

                primaryText:
                primaryText,

                secondaryText:
                secondaryText,
              ),

              const SizedBox(height: 20),

              buildDateField(

                label:
                "Target Date",

                value:
                targetDate == null

                    ? 'Today'

                    : '${targetDate!.day}/${targetDate!.month}/${targetDate!.year}',

                onTap: () {

                  pickDate(false);
                },

                cardColor:
                cardColor,

                primaryText:
                primaryText,

                secondaryText:
                secondaryText,
              ),

              const SizedBox(height: 28),

              Row(

                children: [

                  Expanded(

                    child:
                    GestureDetector(

                      onTap:
                      calculateAge,

                      child:
                      Container(

                        height: 58,

                        alignment:
                        Alignment.center,

                        decoration:
                        BoxDecoration(

                          color:
                          Colors.orange,

                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),

                        child:
                        const Text(

                          "Calculate Age",

                          style:
                          TextStyle(

                            fontSize:
                            18,

                            fontWeight:
                            FontWeight.bold,

                            color:
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  GestureDetector(

                    onTap:
                    clearAll,

                    child:
                    Container(

                      height: 58,

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 22,
                      ),

                      alignment:
                      Alignment.center,

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.red,

                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                      ),

                      child:
                      const Text(

                        "AC",

                        style:
                        TextStyle(

                          fontSize:
                          18,

                          fontWeight:
                          FontWeight.bold,

                          color:
                          Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              if (showResult)

                GridView.builder(

                  shrinkWrap: true,

                  primary: false,

                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount:
                  results.length,

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 2,

                    crossAxisSpacing:
                    12,

                    mainAxisSpacing:
                    12,

                    childAspectRatio:
                    1.25,
                  ),

                  itemBuilder:
                      (context, index) {

                    return Container(

                      padding:
                      const EdgeInsets.all(
                        18,
                      ),

                      decoration:
                      BoxDecoration(

                        color:
                        cardColor,

                        borderRadius:
                        BorderRadius.circular(
                          22,
                        ),
                      ),

                      child: Column(

                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Text(

                            results[index][0],

                            style:
                            TextStyle(

                              fontSize:
                              14,

                              color:
                              secondaryText,
                            ),
                          ),

                          const SizedBox(
                              height: 10),

                          Text(

                            results[index][1],

                            style:
                            TextStyle(

                              fontSize:
                              18,

                              fontWeight:
                              FontWeight.bold,

                              color:
                              primaryText,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}