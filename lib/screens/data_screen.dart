import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class DataScreen extends StatefulWidget {

  final bool isDark;
  final VoidCallback toggleTheme;

  const DataScreen({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<DataScreen> createState() =>
      _DataScreenState();
}

class _DataScreenState
    extends State<DataScreen> {

  final GlobalKey<ScaffoldState>
  scaffoldKey =
  GlobalKey<ScaffoldState>();

  final TextEditingController
  valueController =
  TextEditingController();

  String selectedUnit = 'mb';

  bool showResult = false;

  final Map<String, double> dataBits = {

    'bit': 1,

    'byte': 8,

    'kb': 8 * 1024,

    'mb': 8 * 1024 * 1024,

    'gb':
    8 *
        1024 *
        1024 *
        1024,

    'tb':
    8 *
        1024 *
        1024 *
        1024 *
        1024,

    'pb':
    8 *
        1024 *
        1024 *
        1024 *
        1024 *
        1024,
  };

  final Map<String, String>
  dataNames = {

    'bit': 'Bit',

    'byte': 'Byte (B)',

    'kb': 'Kilobyte (KB)',

    'mb': 'Megabyte (MB)',

    'gb': 'Gigabyte (GB)',

    'tb': 'Terabyte (TB)',

    'pb': 'Petabyte (PB)',
  };

  Map<String, String> results = {};

  void clearAll() {

    FocusScope.of(context)
        .unfocus();

    valueController.clear();

    setState(() {

      selectedUnit = 'mb';

      showResult = false;

      results.clear();
    });
  }

  String formatNumber(
      double value,
      ) {

    if (value < 0.0001 &&
        value != 0) {

      return value
          .toStringAsExponential(
        4,
      );
    }

    return value
        .toStringAsFixed(6)
        .replaceAll(
      RegExp(r'0+$'),
      '',
    )
        .replaceAll(
      RegExp(r'\.$'),
      '',
    );
  }

  void convertData() {

    FocusScope.of(context)
        .unfocus();

    double value =
        double.tryParse(
          valueController.text,
        ) ??
            0;

    if (value <= 0) {

      setState(() {

        showResult = false;
      });

      return;
    }

    double bits =
        value *
            dataBits[
            selectedUnit]!;

    Map<String, String>
    converted = {};

    for (String unit
    in dataBits.keys) {

      double result =
          bits /
              dataBits[unit]!;

      converted[
      dataNames[unit]!] =
          formatNumber(
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
        AppDrawer.dataRoute,
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

              "Data Converter",

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

                "Value",

                "Enter value",

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
                    dataNames.entries.map(

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
                      convertData,

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