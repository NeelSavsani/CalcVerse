import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class TemperatureScreen extends StatefulWidget {

  final bool isDark;
  final VoidCallback toggleTheme;

  const TemperatureScreen({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<TemperatureScreen> createState() =>
      _TemperatureScreenState();
}

class _TemperatureScreenState
    extends State<TemperatureScreen> {

  final GlobalKey<ScaffoldState>
  scaffoldKey =
  GlobalKey<ScaffoldState>();

  final TextEditingController
  valueController =
  TextEditingController();

  String selectedUnit = 'C';

  bool showResult = false;

  final Map<String, String>
  tempNames = {

    'C': 'Celsius (°C)',

    'F': 'Fahrenheit (°F)',

    'K': 'Kelvin (K)',

    'R': 'Rankine (°R)',
  };

  Map<String, String> results = {};

  void clearAll() {

    FocusScope.of(context)
        .unfocus();

    valueController.clear();

    setState(() {

      selectedUnit = 'C';

      showResult = false;

      results.clear();
    });
  }

  double toCelsius(
      double value,
      String from,
      ) {

    if (from == 'C') {

      return value;
    }

    if (from == 'F') {

      return ((value - 32) * 5) / 9;
    }

    if (from == 'K') {

      return value - 273.15;
    }

    if (from == 'R') {

      return ((value - 491.67) * 5) / 9;
    }

    return value;
  }

  double fromCelsius(
      double celsius,
      String to,
      ) {

    if (to == 'C') {

      return celsius;
    }

    if (to == 'F') {

      return
        (celsius * 9) / 5 + 32;
    }

    if (to == 'K') {

      return celsius + 273.15;
    }

    if (to == 'R') {

      return
        ((celsius + 273.15) * 9) / 5;
    }

    return celsius;
  }

  String formatValue(
      double value,
      ) {

    return value
        .toStringAsFixed(4)
        .replaceAll(
      RegExp(r'0+$'),
      '',
    )
        .replaceAll(
      RegExp(r'\.$'),
      '',
    );
  }

  void convertTemperature() {

    FocusScope.of(context)
        .unfocus();

    double value =
        double.tryParse(
          valueController.text,
        ) ??
            0;

    double celsius =
    toCelsius(
      value,
      selectedUnit,
    );

    Map<String, String>
    converted = {};

    for (String unit
    in tempNames.keys) {

      double result =
      fromCelsius(
        celsius,
        unit,
      );

      converted[
      tempNames[unit]!] =
          formatValue(
            result,
          );
    }

    setState(() {

      results = converted;

      showResult = true;
    });
  }

  Widget buildInput(
      String label,
      String hint,
      TextEditingController
      controller,
      Color cardColor,
      Color primaryText,
      Color secondaryText,
      ) {

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

        Container(

          decoration: BoxDecoration(

            color: cardColor,

            borderRadius:
            BorderRadius.circular(
              18,
            ),
          ),

          child: TextField(

            controller: controller,

            keyboardType:
            const TextInputType
                .numberWithOptions(
              decimal: true,
            ),

            style: TextStyle(

              color: primaryText,

              fontSize: 18,
            ),

            decoration:
            InputDecoration(

              hintText: hint,

              hintStyle: TextStyle(

                color:
                secondaryText,
              ),

              border:
              InputBorder.none,

              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildResultCard(
      String title,
      String value,
      Color cardColor,
      Color primaryText,
      Color secondaryText,
      ) {

    return Container(

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: cardColor,

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

            title,

            style: TextStyle(

              fontSize: 14,

              color:
              secondaryText,
            ),
          ),

          const SizedBox(height: 8),

          Text(

            value,

            maxLines: 2,

            overflow:
            TextOverflow.ellipsis,

            style: TextStyle(

              fontSize: 20,

              fontWeight:
              FontWeight.bold,

              color:
              primaryText,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final Color bgColor =
    isDark
        ? const Color(0xFF0D1326)
        : Colors.white;

    final Color cardColor =
    isDark
        ? const Color(0xFF1A2238)
        : const Color(0xFFF4F4F4);

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

      resizeToAvoidBottomInset:
      true,

      backgroundColor:
      bgColor,

      drawer: const AppDrawer(
        currentRoute:
        AppDrawer.temperatureRoute,
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

                FocusManager.instance.primaryFocus?.unfocus();

                Future.delayed(
                  const Duration(milliseconds: 100),
                      () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                );
              },

              child: Icon(

                Icons.menu,

                color:
                primaryText,
              ),
            ),

            Text(

              "Temperature Converter",

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

        child: SingleChildScrollView(

          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior
              .onDrag,

          padding:
          const EdgeInsets.all(
            20,
          ),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment
                .start,

            children: [

              buildInput(

                "Temperature",

                "Enter temperature",

                valueController,

                cardColor,

                primaryText,

                secondaryText,
              ),

              const SizedBox(height: 20),

              Text(

                "From Unit",

                style: TextStyle(

                  fontSize: 15,

                  fontWeight:
                  FontWeight.w500,

                  color:
                  secondaryText,
                ),
              ),

              const SizedBox(height: 8),

              Container(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 18,
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

                child:
                DropdownButtonHideUnderline(

                  child:
                  DropdownButton<String>(

                    value:
                    selectedUnit,

                    dropdownColor:
                    cardColor,

                    isExpanded:
                    true,

                    style:
                    TextStyle(
                      color:
                      primaryText,
                    ),

                    items:
                    tempNames.entries.map(

                          (entry) {

                        return DropdownMenuItem(

                          value:
                          entry.key,

                          child: Text(
                            entry.value,
                          ),
                        );
                      },
                    ).toList(),

                    onChanged:
                        (value) {

                      setState(() {

                        selectedUnit =
                        value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Row(

                children: [

                  Expanded(

                    child:
                    GestureDetector(

                      onTap:
                      convertTemperature,

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

                          "Convert All",

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

                    onTap: clearAll,

                    child: Container(

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
                    1.15,
                  ),

                  itemBuilder:
                      (context, index) {

                    String key =
                    results.keys
                        .elementAt(
                      index,
                    );

                    return buildResultCard(

                      key,

                      results[key]!,

                      cardColor,

                      primaryText,

                      secondaryText,
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