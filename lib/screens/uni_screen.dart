import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class UniScreen extends StatefulWidget {

  final bool isDark;
  final VoidCallback toggleTheme;

  const UniScreen({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<UniScreen> createState() =>
      _UniScreenState();
}

class _UniScreenState
    extends State<UniScreen> {

  final GlobalKey<ScaffoldState>
  scaffoldKey =
  GlobalKey<ScaffoldState>();

  final TextEditingController
  valueController =
  TextEditingController();

  String selectedCategory =
      'length';

  int fromIndex = 0;

  int toIndex = 1;

  bool showResult = false;

  String resultText = '';

  final Map<String, dynamic>
  unitData = {

    'length': {

      'labels': [

        'Millimeter',
        'Centimeter',
        'Meter',
        'Kilometer',
        'Inch',
        'Foot',
        'Yard',
        'Mile',
      ],

      'toBase': [

        0.001,
        0.01,
        1,
        1000,
        0.0254,
        0.3048,
        0.9144,
        1609.344,
      ],
    },

    'weight': {

      'labels': [

        'Milligram',
        'Gram',
        'Kilogram',
        'Tonne',
        'Ounce',
        'Pound',
      ],

      'toBase': [

        0.000001,
        0.001,
        1,
        1000,
        0.0283495,
        0.453592,
      ],
    },

    'speed': {

      'labels': [

        'm/s',
        'km/h',
        'mph',
        'Knot',
        'ft/s',
      ],

      'toBase': [

        1,
        0.27778,
        0.44704,
        0.514444,
        0.3048,
      ],
    },

    'area': {

      'labels': [

        'mm²',
        'cm²',
        'm²',
        'km²',
        'in²',
        'ft²',
        'Acre',
        'Hectare',
      ],

      'toBase': [

        0.000001,
        0.0001,
        1,
        1000000,
        0.00064516,
        0.092903,
        4046.86,
        10000,
      ],
    },

    'volume': {

      'labels': [

        'mL',
        'Liter',
        'm³',
        'cm³',
        'fl oz',
        'Cup',
        'Pint',
        'Gallon',
      ],

      'toBase': [

        0.001,
        1,
        1000,
        0.001,
        0.0295735,
        0.236588,
        0.473176,
        3.78541,
      ],
    },

    'time': {

      'labels': [

        'Millisecond',
        'Second',
        'Minute',
        'Hour',
        'Day',
        'Week',
        'Month',
        'Year',
      ],

      'toBase': [

        0.001,
        1,
        60,
        3600,
        86400,
        604800,
        2629746,
        31556952,
      ],
    },
  };

  void clearAll() {

    FocusScope.of(context)
        .unfocus();

    valueController.clear();

    setState(() {

      selectedCategory =
      'length';

      fromIndex = 0;

      toIndex = 1;

      showResult = false;

      resultText = '';
    });
  }

  void convertUnit() {

    FocusScope.of(context)
        .unfocus();

    double value =
        double.tryParse(
          valueController.text,
        ) ??
            0;

    if (value == 0) {

      return;
    }

    List labels =
    unitData[selectedCategory]
    ['labels'];

    List toBase =
    unitData[selectedCategory]
    ['toBase'];

    double base =
        value *
            toBase[fromIndex];

    double result =
        base /
            toBase[toIndex];

    double finalResult =
    double.parse(
      result.toStringAsFixed(
        8,
      ),
    );

    setState(() {

      resultText =
      '$value ${labels[fromIndex]} = $finalResult ${labels[toIndex]}';

      showResult = true;
    });
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

    List labels =
    unitData[selectedCategory]
    ['labels'];

    return Scaffold(

      key: scaffoldKey,

      resizeToAvoidBottomInset:
      true,

      backgroundColor:
      bgColor,

      drawer: const AppDrawer(
        currentRoute:
        AppDrawer.unitRoute,
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

                FocusManager.instance.primaryFocus
                    ?.unfocus();

                Future.delayed(

                  const Duration(
                    milliseconds: 100,
                  ),

                      () {

                    scaffoldKey.currentState
                        ?.openDrawer();
                  },
                );
              },

              child: Icon(

                Icons.menu,

                color: primaryText,
              ),
            ),

            Text(

              "Unit Converter",

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

              // CATEGORY

              Text(

                "Category",

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
                    selectedCategory,

                    dropdownColor:
                    cardColor,

                    isExpanded:
                    true,

                    style:
                    TextStyle(
                      color:
                      primaryText,
                    ),

                    items: [

                      'length',
                      'weight',
                      'speed',
                      'area',
                      'volume',
                      'time',
                    ].map((category) {

                      return DropdownMenuItem(

                        value:
                        category,

                        child: Text(
                          category
                              .toUpperCase(),
                        ),
                      );
                    }).toList(),

                    onChanged:
                        (value) {

                      setState(() {

                        selectedCategory =
                        value!;

                        fromIndex = 0;

                        toIndex = 1;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // FROM & TO

              Row(

                children: [

                  Expanded(

                    child:
                    Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(

                          "From",

                          style:
                          TextStyle(

                            fontSize:
                            15,

                            fontWeight:
                            FontWeight
                                .w500,

                            color:
                            secondaryText,
                          ),
                        ),

                        const SizedBox(
                            height: 8),

                        Container(

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal:
                            18,
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
                            DropdownButton<int>(

                              value:
                              fromIndex,

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
                              List.generate(
                                labels.length,
                                    (index) {

                                  return DropdownMenuItem(

                                    value:
                                    index,

                                    child:
                                    Text(
                                      labels[index],
                                    ),
                                  );
                                },
                              ),

                              onChanged:
                                  (value) {

                                setState(() {

                                  fromIndex =
                                  value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(

                    child:
                    Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(

                          "To",

                          style:
                          TextStyle(

                            fontSize:
                            15,

                            fontWeight:
                            FontWeight
                                .w500,

                            color:
                            secondaryText,
                          ),
                        ),

                        const SizedBox(
                            height: 8),

                        Container(

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal:
                            18,
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
                            DropdownButton<int>(

                              value:
                              toIndex,

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
                              List.generate(
                                labels.length,
                                    (index) {

                                  return DropdownMenuItem(

                                    value:
                                    index,

                                    child:
                                    Text(
                                      labels[index],
                                    ),
                                  );
                                },
                              ),

                              onChanged:
                                  (value) {

                                setState(() {

                                  toIndex =
                                  value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // VALUE

              Text(

                "Value",

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

                decoration:
                BoxDecoration(

                  color:
                  cardColor,

                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),

                child: TextField(

                  controller:
                  valueController,

                  keyboardType:
                  const TextInputType
                      .numberWithOptions(
                    decimal: true,
                  ),

                  style: TextStyle(

                    color:
                    primaryText,

                    fontSize: 18,
                  ),

                  decoration:
                  InputDecoration(

                    hintText:
                    "Enter value",

                    hintStyle:
                    TextStyle(

                      color:
                      secondaryText,
                    ),

                    border:
                    InputBorder.none,

                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal:
                      18,
                      vertical: 18,
                    ),
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
                      convertUnit,

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

                          "Convert",

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

                Container(

                  width:
                  double.infinity,

                  padding:
                  const EdgeInsets.all(
                    20,
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

                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      Text(

                        "Result",

                        style: TextStyle(

                          fontSize: 15,

                          color:
                          secondaryText,
                        ),
                      ),

                      const SizedBox(
                          height: 10),

                      Text(

                        resultText,

                        style: TextStyle(

                          fontSize: 22,

                          fontWeight:
                          FontWeight.bold,

                          color:
                          primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}