import 'dart:math';
import 'package:flutter/material.dart';

class TrigoScreen extends StatefulWidget {

  final bool isDark;
  final VoidCallback toggleTheme;

  const TrigoScreen({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<TrigoScreen> createState() =>
      _TrigoScreenState();
}

class _TrigoScreenState
    extends State<TrigoScreen> {

  final TextEditingController
  angleController =
  TextEditingController();

  String selectedUnit = "deg";

  String result = "—";

  // HYPERBOLIC FUNCTIONS

  double sinhCustom(double x) {

    return (exp(x) - exp(-x)) / 2;
  }

  double coshCustom(double x) {

    return (exp(x) + exp(-x)) / 2;
  }

  double tanhCustom(double x) {

    return sinhCustom(x) /
        coshCustom(x);
  }

  // CLEAR FUNCTION
  void clearAll() {

    setState(() {

      angleController.clear();

      result = "—";
    });
  }

  void calculateTrig(String fn) {

    double? value =
    double.tryParse(
      angleController.text,
    );

    if (value == null) {

      setState(() {

        result = "Enter a value";
      });

      return;
    }

    double rad =
    selectedUnit == "deg"
        ? value * pi / 180
        : value;

    double res;

    try {

      switch (fn) {

        case 'sin':
          res = sin(rad);
          break;

        case 'cos':
          res = cos(rad);
          break;

        case 'tan':
          res = tan(rad);
          break;

        case 'asin':
          res =
              asin(value) *
                  (selectedUnit == "deg"
                      ? 180 / pi
                      : 1);
          break;

        case 'acos':
          res =
              acos(value) *
                  (selectedUnit == "deg"
                      ? 180 / pi
                      : 1);
          break;

        case 'atan':
          res =
              atan(value) *
                  (selectedUnit == "deg"
                      ? 180 / pi
                      : 1);
          break;

        case 'sinh':
          res = sinhCustom(rad);
          break;

        case 'cosh':
          res = coshCustom(rad);
          break;

        case 'tanh':
          res = tanhCustom(rad);
          break;

        case 'log':
          res = log(value) / ln10;
          break;

        case 'ln':
          res = log(value);
          break;

        case 'exp':
          res = exp(value);
          break;

        default:
          res = double.nan;
      }

      setState(() {

        result =
        res.isNaN || res.isInfinite
            ? "Undefined"
            : res
            .toStringAsFixed(10)
            .replaceAll(
          RegExp(r'0+$'),
          '',
        )
            .replaceAll(
          RegExp(r'\.$'),
          '',
        );
      });
    }

    catch (e) {

      setState(() {

        result = "Undefined";
      });
    }
  }

  Widget buildTrigButton(
      String text,
      String fn,
      Color bgColor,
      Color textColor,
      ) {

    return GestureDetector(

      onTap: () {

        calculateTrig(fn);
      },

      child: Container(

        height: 58,

        alignment: Alignment.center,

        decoration: BoxDecoration(

          color: bgColor,

          borderRadius:
          BorderRadius.circular(18),

          boxShadow: [

            BoxShadow(

              color:
              Colors.black.withOpacity(
                0.08,
              ),

              blurRadius: 6,

              offset:
              const Offset(0, 3),
            ),
          ],
        ),

        child: Text(

          text,

          style: TextStyle(

            fontSize: 18,

            fontWeight:
            FontWeight.w600,

            color: textColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final bgColor =
    widget.isDark
        ? const Color(0xFF0D1326)
        : Colors.white;

    final cardColor =
    widget.isDark
        ? const Color(0xFF1A2238)
        : const Color(0xFFF4F4F4);

    final primaryText =
    widget.isDark
        ? Colors.white
        : Colors.black;

    final secondaryText =
    widget.isDark
        ? Colors.grey.shade400
        : Colors.grey.shade700;

    return Scaffold(

      backgroundColor: bgColor,

      appBar: AppBar(

        elevation: 0,

        backgroundColor: bgColor,

        iconTheme: IconThemeData(

          color: primaryText,
        ),

        title: Text(

          "Trigonometry",

          style: TextStyle(

            color: primaryText,

            fontWeight:
            FontWeight.bold,
          ),
        ),

        actions: [

          // THEME BUTTON
          IconButton(

            onPressed:
            widget.toggleTheme,

            icon: Icon(

              widget.isDark
                  ? Icons.light_mode
                  : Icons.dark_mode,

              color: primaryText,
            ),
          ),
        ],
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // INPUT FIELD
              Text(

                "Angle Value",

                style: TextStyle(

                  fontSize: 16,

                  fontWeight:
                  FontWeight.w500,

                  color: secondaryText,
                ),
              ),

              const SizedBox(height: 10),

              // INPUT + AC BUTTON
              Row(

                children: [

                  // INPUT FIELD
                  Expanded(

                    flex: 75,

                    child: Container(

                      decoration: BoxDecoration(

                        color: cardColor,

                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                      ),

                      child: TextField(

                        controller:
                        angleController,

                        keyboardType:
                        const TextInputType
                            .numberWithOptions(
                          decimal: true,
                        ),

                        style: TextStyle(

                          fontSize: 20,

                          color:
                          primaryText,
                        ),

                        decoration:
                        InputDecoration(

                          hintText:
                          "e.g. 45",

                          hintStyle:
                          TextStyle(

                            color:
                            secondaryText,
                          ),

                          border:
                          InputBorder.none,

                          contentPadding:
                          const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // AC BUTTON
                  Expanded(

                    flex: 20,

                    child: GestureDetector(

                      onTap: clearAll,

                      child: Container(

                        height: 60,

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

                          boxShadow: [

                            BoxShadow(

                              color:
                              Colors.black
                                  .withOpacity(
                                0.08,
                              ),

                              blurRadius: 6,

                              offset:
                              const Offset(
                                0,
                                3,
                              ),
                            ),
                          ],
                        ),

                        child: const Text(

                          "AC",

                          style: TextStyle(

                            fontSize: 18,

                            fontWeight:
                            FontWeight.bold,

                            color:
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // DROPDOWN
              Text(

                "Unit",

                style: TextStyle(

                  fontSize: 16,

                  fontWeight:
                  FontWeight.w500,

                  color: secondaryText,
                ),
              ),

              const SizedBox(height: 10),

              Container(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                decoration: BoxDecoration(

                  color: cardColor,

                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),

                child:
                DropdownButtonHideUnderline(

                  child:
                  DropdownButton<String>(

                    value: selectedUnit,

                    dropdownColor:
                    cardColor,

                    isExpanded: true,

                    style: TextStyle(

                      color:
                      primaryText,

                      fontSize: 18,
                    ),

                    items: const [

                      DropdownMenuItem(

                        value: "deg",

                        child: Text(
                          "Degrees °",
                        ),
                      ),

                      DropdownMenuItem(

                        value: "rad",

                        child: Text(
                          "Radians",
                        ),
                      ),
                    ],

                    onChanged: (value) {

                      setState(() {

                        selectedUnit =
                        value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // BUTTONS
              GridView.count(

                shrinkWrap: true,

                physics:
                const NeverScrollableScrollPhysics(),

                crossAxisCount: 3,

                crossAxisSpacing: 14,

                mainAxisSpacing: 14,

                childAspectRatio: 1.5,

                children: [

                  buildTrigButton(
                    "sin",
                    "sin",
                    cardColor,
                    primaryText,
                  ),

                  buildTrigButton(
                    "cos",
                    "cos",
                    cardColor,
                    primaryText,
                  ),

                  buildTrigButton(
                    "tan",
                    "tan",
                    cardColor,
                    primaryText,
                  ),

                  buildTrigButton(
                    "sin⁻¹",
                    "asin",
                    cardColor,
                    primaryText,
                  ),

                  buildTrigButton(
                    "cos⁻¹",
                    "acos",
                    cardColor,
                    primaryText,
                  ),

                  buildTrigButton(
                    "tan⁻¹",
                    "atan",
                    cardColor,
                    primaryText,
                  ),

                  buildTrigButton(
                    "sinh",
                    "sinh",
                    cardColor,
                    primaryText,
                  ),

                  buildTrigButton(
                    "cosh",
                    "cosh",
                    cardColor,
                    primaryText,
                  ),

                  buildTrigButton(
                    "tanh",
                    "tanh",
                    cardColor,
                    primaryText,
                  ),

                  buildTrigButton(
                    "log₁₀",
                    "log",
                    cardColor,
                    primaryText,
                  ),

                  buildTrigButton(
                    "ln",
                    "ln",
                    cardColor,
                    primaryText,
                  ),

                  buildTrigButton(
                    "eˣ",
                    "exp",
                    cardColor,
                    primaryText,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // RESULT BOX
              Container(

                width: double.infinity,

                padding:
                const EdgeInsets.all(24),

                decoration: BoxDecoration(

                  color: cardColor,

                  borderRadius:
                  BorderRadius.circular(
                    24,
                  ),

                  boxShadow: [

                    BoxShadow(

                      color:
                      Colors.black.withOpacity(
                        0.06,
                      ),

                      blurRadius: 8,

                      offset:
                      const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(

                      "Result",

                      style: TextStyle(

                        fontSize: 16,

                        fontWeight:
                        FontWeight.w500,

                        color:
                        secondaryText,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(

                      result,

                      style: TextStyle(

                        fontSize: 34,

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