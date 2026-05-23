import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class GeoScreen extends StatefulWidget {

  final bool isDark;
  final VoidCallback toggleTheme;

  const GeoScreen({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<GeoScreen> createState() =>
      _GeoScreenState();
}

class _GeoScreenState
    extends State<GeoScreen> {

  final GlobalKey<ScaffoldState>
  scaffoldKey =
  GlobalKey<ScaffoldState>();

  String selectedShape = "circle";

  // CONTROLLERS

  final TextEditingController circleRadius =
  TextEditingController();

  final TextEditingController rectLength =
  TextEditingController();

  final TextEditingController rectWidth =
  TextEditingController();

  final TextEditingController triA =
  TextEditingController();

  final TextEditingController triB =
  TextEditingController();

  final TextEditingController triC =
  TextEditingController();

  final TextEditingController cubeSide =
  TextEditingController();

  final TextEditingController cylRadius =
  TextEditingController();

  final TextEditingController cylHeight =
  TextEditingController();

  final TextEditingController sphereRadius =
  TextEditingController();

  final TextEditingController coneRadius =
  TextEditingController();

  final TextEditingController coneHeight =
  TextEditingController();

  Map<String, String> results = {};

  double parse(TextEditingController c) {

    return double.tryParse(c.text) ?? 0;
  }

  String fmt(double n) {

    if (n.isNaN || n.isInfinite) {

      return "—";
    }

    return n
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

  void clearAll() {

    for (var controller in [

      circleRadius,

      rectLength,
      rectWidth,

      triA,
      triB,
      triC,

      cubeSide,

      cylRadius,
      cylHeight,

      sphereRadius,

      coneRadius,
      coneHeight,
    ]) {

      controller.clear();
    }

    setState(() {

      results.clear();
    });
  }

  void calculateShape() {

    // HIDE KEYBOARD
    FocusScope.of(context).unfocus();

    const PI = pi;

    setState(() {

      results.clear();

      if (selectedShape == "circle") {

        double r = parse(circleRadius);

        results = {

          "Area":
          fmt(PI * r * r),

          "Perimeter":
          fmt(2 * PI * r),

          "Diameter":
          fmt(2 * r),
        };
      }

      else if (selectedShape ==
          "rectangle") {

        double l =
        parse(rectLength);

        double w =
        parse(rectWidth);

        results = {

          "Area":
          fmt(l * w),

          "Perimeter":
          fmt(2 * (l + w)),

          "Diagonal":
          fmt(
            sqrt(l * l + w * w),
          ),
        };
      }

      else if (selectedShape ==
          "triangle") {

        double a = parse(triA);

        double b = parse(triB);

        double c = parse(triC);

        double s =
            (a + b + c) / 2;

        double area =
        sqrt(
          s *
              (s - a) *
              (s - b) *
              (s - c),
        );

        results = {

          "Area":
          fmt(area),

          "Perimeter":
          fmt(a + b + c),
        };
      }

      else if (selectedShape ==
          "cube") {

        double s =
        parse(cubeSide);

        results = {

          "Volume":
          fmt(pow(s, 3).toDouble()),

          "Surface Area":
          fmt(6 * s * s),
        };
      }

      else if (selectedShape ==
          "cylinder") {

        double r =
        parse(cylRadius);

        double h =
        parse(cylHeight);

        results = {

          "Volume":
          fmt(
            PI * r * r * h,
          ),

          "Curved SA":
          fmt(
            2 * PI * r * h,
          ),

          "Total SA":
          fmt(
            2 *
                PI *
                r *
                (r + h),
          ),
        };
      }

      else if (selectedShape ==
          "sphere") {

        double r =
        parse(sphereRadius);

        results = {

          "Volume":
          fmt(
            (4 / 3) *
                PI *
                pow(r, 3),
          ),

          "Surface Area":
          fmt(
            4 * PI * r * r,
          ),
        };
      }

      else if (selectedShape ==
          "cone") {

        double r =
        parse(coneRadius);

        double h =
        parse(coneHeight);

        double l =
        sqrt(r * r + h * h);

        results = {

          "Volume":
          fmt(
            (1 / 3) *
                PI *
                r *
                r *
                h,
          ),

          "Slant Height":
          fmt(l),

          "Total SA":
          fmt(
            PI * r * (r + l),
          ),
        };
      }
    });
  }

  Widget buildInput(
      String label,
      TextEditingController controller,
      Color cardColor,
      Color primaryText,
      Color secondaryText,
      ) {

    return Expanded(

      child: Column(

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

                hintText: "Enter",

                hintStyle: TextStyle(

                  color:
                  secondaryText,
                ),

                border:
                InputBorder.none,

                contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildShapeButton(
      String shape,
      Color cardColor,
      Color primaryText,
      ) {

    bool active =
        selectedShape == shape;

    return GestureDetector(

      onTap: () {

        setState(() {

          selectedShape = shape;

          results.clear();
        });
      },

      child: Container(

        padding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        decoration: BoxDecoration(

          color:
          active
              ? Colors.orange
              : cardColor,

          borderRadius:
          BorderRadius.circular(
            18,
          ),
        ),

        child: Text(

          shape[0]
              .toUpperCase() +
              shape.substring(1),

          style: TextStyle(

            color:
            active
                ? Colors.white
                : primaryText,

            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildResultCard(
      String label,
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

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(

            label,

            style: TextStyle(

              fontSize: 15,

              color:
              secondaryText,
            ),
          ),

          const SizedBox(height: 8),

          Text(

            value,

            style: TextStyle(

              fontSize: 28,

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

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final bgColor =
    isDark
        ? const Color(0xFF0D1326)
        : Colors.white;

    final cardColor =
    isDark
        ? const Color(0xFF1A2238)
        : const Color(0xFFF4F4F4);

    final primaryText =
    isDark
        ? Colors.white
        : Colors.black;

    final secondaryText =
    isDark
        ? Colors.grey.shade400
        : Colors.grey.shade700;

    return Scaffold(

      resizeToAvoidBottomInset: false,

      key: scaffoldKey,

      backgroundColor: bgColor,

      drawer: const AppDrawer(
        currentRoute: AppDrawer.geometryRoute,
      ),

      // APP BAR

      appBar: AppBar(

        elevation: 0,

        backgroundColor: bgColor,

        automaticallyImplyLeading: false,

        title: Row(

          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

          children: [

            // MENU BUTTON

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

                color: primaryText,
              ),
            ),

            Text(

              "Geometry",

              style: TextStyle(

                color: primaryText,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            // THEME BUTTON

            IconButton(

              onPressed: () {

                widget.toggleTheme();

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

                color: primaryText,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // SHAPE BUTTONS

              Wrap(

                spacing: 10,

                runSpacing: 10,

                children: [

                  buildShapeButton(
                    "circle",
                    cardColor,
                    primaryText,
                  ),

                  buildShapeButton(
                    "rectangle",
                    cardColor,
                    primaryText,
                  ),

                  buildShapeButton(
                    "triangle",
                    cardColor,
                    primaryText,
                  ),

                  buildShapeButton(
                    "cube",
                    cardColor,
                    primaryText,
                  ),

                  buildShapeButton(
                    "cylinder",
                    cardColor,
                    primaryText,
                  ),

                  buildShapeButton(
                    "sphere",
                    cardColor,
                    primaryText,
                  ),

                  buildShapeButton(
                    "cone",
                    cardColor,
                    primaryText,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // INPUTS

              if (selectedShape ==
                  "circle")

                Row(

                  children: [

                    buildInput(
                      "Radius",
                      circleRadius,
                      cardColor,
                      primaryText,
                      secondaryText,
                    ),
                  ],
                ),

              if (selectedShape ==
                  "rectangle")

                Row(

                  children: [

                    buildInput(
                      "Length",
                      rectLength,
                      cardColor,
                      primaryText,
                      secondaryText,
                    ),

                    const SizedBox(width: 12),

                    buildInput(
                      "Width",
                      rectWidth,
                      cardColor,
                      primaryText,
                      secondaryText,
                    ),
                  ],
                ),

              if (selectedShape ==
                  "triangle")

                Row(

                  children: [

                    buildInput(
                      "Side A",
                      triA,
                      cardColor,
                      primaryText,
                      secondaryText,
                    ),

                    const SizedBox(width: 10),

                    buildInput(
                      "Side B",
                      triB,
                      cardColor,
                      primaryText,
                      secondaryText,
                    ),

                    const SizedBox(width: 10),

                    buildInput(
                      "Side C",
                      triC,
                      cardColor,
                      primaryText,
                      secondaryText,
                    ),
                  ],
                ),

              if (selectedShape ==
                  "cube")

                Row(

                  children: [

                    buildInput(
                      "Side",
                      cubeSide,
                      cardColor,
                      primaryText,
                      secondaryText,
                    ),
                  ],
                ),

              if (selectedShape ==
                  "cylinder")

                Row(

                  children: [

                    buildInput(
                      "Radius",
                      cylRadius,
                      cardColor,
                      primaryText,
                      secondaryText,
                    ),

                    const SizedBox(width: 12),

                    buildInput(
                      "Height",
                      cylHeight,
                      cardColor,
                      primaryText,
                      secondaryText,
                    ),
                  ],
                ),

              if (selectedShape ==
                  "sphere")

                Row(

                  children: [

                    buildInput(
                      "Radius",
                      sphereRadius,
                      cardColor,
                      primaryText,
                      secondaryText,
                    ),
                  ],
                ),

              if (selectedShape ==
                  "cone")

                Row(

                  children: [

                    buildInput(
                      "Radius",
                      coneRadius,
                      cardColor,
                      primaryText,
                      secondaryText,
                    ),

                    const SizedBox(width: 12),

                    buildInput(
                      "Height",
                      coneHeight,
                      cardColor,
                      primaryText,
                      secondaryText,
                    ),
                  ],
                ),

              const SizedBox(height: 26),

              // BUTTONS

              Row(

                children: [

                  Expanded(

                    child: GestureDetector(

                      onTap:
                      calculateShape,

                      child: Container(

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

                        child: const Text(

                          "Calculate",

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
                ],
              ),

              const SizedBox(height: 30),

              // RESULTS

              if (results.isNotEmpty)

                GridView.builder(

                  shrinkWrap: true,

                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount:
                  results.length,

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 1,

                    mainAxisSpacing: 14,

                    childAspectRatio: 2.6,
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
