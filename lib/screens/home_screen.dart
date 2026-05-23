import 'package:flutter/material.dart';

import '../utils/calculator_logic.dart';
import '../widgets/calc_button.dart';

import 'emi_screen.dart';
import 'geo_screen.dart';
import 'history_screen.dart';
import 'trigo_screen.dart';

class HomeScreen extends StatefulWidget {

  final bool isDark;
  final VoidCallback toggleTheme;

  const HomeScreen({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  static const String backspace =
      '\u232b';

  static const String divide =
      '\u00f7';

  static const String multiply =
      '\u00d7';

  String expression = '';

  String result = '0';

  bool isResultFinal = false;

  final List<String> history = [];

  final List<String> buttons = const [

    'AC',
    backspace,
    '%',
    divide,

    '7',
    '8',
    '9',
    multiply,

    '4',
    '5',
    '6',
    '-',

    '1',
    '2',
    '3',
    '+',

    '00',
    '0',
    '.',
    '=',
  ];

  void clearHistory() {

    setState(() {

      history.clear();
    });
  }

  bool isOperator(String value) {

    return [
      '%',
      divide,
      multiply,
      '-',
      '+',
      '='
    ].contains(value);
  }

  bool isNumberOrDot(
      String value,
      ) {

    return [

      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '00',
      '.'

    ].contains(value);
  }

  bool endsWithOperator(
      String value,
      ) {

    if (value.isEmpty) {

      return false;
    }

    final String lastChar =
    value[value.length - 1];

    return [

      '+',
      '-',
      multiply,
      divide,
      '%'

    ].contains(lastChar);
  }

  void openHistoryScreen() {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) =>
            HistoryScreen(

              history: history,

              onClearHistory:
              clearHistory,
            ),
      ),
    );
  }

  void openTrigonometry() {

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
            TrigoScreen(

              isDark:
              widget.isDark,

              toggleTheme:
              widget.toggleTheme,
            ),
      ),
    );
  }

  void openGeometry() {

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
            GeoScreen(

              isDark:
              widget.isDark,

              toggleTheme:
              widget.toggleTheme,
            ),
      ),
    );
  }

  void openEmiCalculator() {

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
            EmiScreen(

              isDark:
              widget.isDark,

              toggleTheme:
              widget.toggleTheme,
            ),
      ),
    );
  }

  void onButtonClick(
      String value,
      ) {

    setState(() {

      if (value == 'AC') {

        expression = '';

        result = '0';

        isResultFinal = false;

        return;
      }

      if (value == backspace) {

        if (expression.isNotEmpty) {

          expression =
              expression.substring(
                0,
                expression.length - 1,
              );

          result =
          expression.isEmpty ||
              endsWithOperator(
                expression,
              )
              ? '0'
              : calculate(
            expression,
          );
        }

        isResultFinal = false;

        return;
      }

      if (value == '=') {

        if (expression.isNotEmpty &&
            !endsWithOperator(
              expression,
            )) {

          result =
              calculate(
                expression,
              );

          isResultFinal = true;

          history.add(
            '$expression = $result',
          );
        }

        return;
      }

      if (isResultFinal) {

        if (isNumberOrDot(value)) {

          expression = value;

          result =
          value == '.'
              ? '0'
              : calculate(
            expression,
          );
        }

        else if (isOperator(value)) {

          expression =
              result + value;
        }

        isResultFinal = false;
      }

      else {

        expression += value;
      }

      if (!endsWithOperator(
        expression,
      )) {

        result =
            calculate(
              expression,
            );
      }
    });
  }

  Widget buildDrawerItem({

    required IconData icon,

    required String title,

    required Color primaryTextColor,

    required VoidCallback onTap,
  }) {

    return ListTile(

      leading: Icon(

        icon,

        color:
        Theme.of(context)
            .brightness ==
            Brightness.dark
            ? Colors.orange
            : Colors.deepOrange,
      ),

      title: Text(

        title,

        style: TextStyle(

          fontSize: 18,

          fontWeight:
          FontWeight.w500,

          color:
          primaryTextColor,
        ),
      ),

      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final double screenWidth =
        MediaQuery.of(context)
            .size
            .width;

    final double screenHeight =
        MediaQuery.of(context)
            .size
            .height;

    final double horizontalPadding =
        screenWidth * 0.05;

    final double topGap =
        screenHeight * 0.04;

    final double buttonSpacing =
        screenWidth * 0.025;

    final double aspectRatio =
    screenHeight < 700
        ? 1.02
        : 1.12;

    final Color bgColor =
    isDark
        ? const Color(0xFF0D1326)
        : Colors.white;

    final Color primaryTextColor =
    isDark
        ? Colors.white
        : Colors.black;

    final Color secondaryTextColor =
    isDark
        ? const Color(0xFF7D8597)
        : Colors.grey.shade500;

    return Scaffold(

      backgroundColor: bgColor,

      // DRAWER

      drawer: Drawer(

        backgroundColor: bgColor,

        child: SafeArea(

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 40),

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
                    primaryTextColor,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ACTIVE SCREEN

              Container(

                color:
                isDark
                    ? const Color(0xFF1A2238)
                    : Colors.grey.shade200,

                child: ListTile(

                  leading: const Icon(

                    Icons.calculate,

                    color:
                    Colors.orange,
                  ),

                  title: Text(

                    'Basic Calculator',

                    style: TextStyle(

                      fontSize: 18,

                      fontWeight:
                      FontWeight.w600,

                      color:
                      primaryTextColor,
                    ),
                  ),
                ),
              ),

              buildDrawerItem(

                icon: Icons.functions,

                title: 'Trigonometry',

                primaryTextColor:
                primaryTextColor,

                onTap:
                openTrigonometry,
              ),

              buildDrawerItem(

                icon:
                Icons.hexagon_outlined,

                title: 'Geometry',

                primaryTextColor:
                primaryTextColor,

                onTap:
                openGeometry,
              ),

              buildDrawerItem(

                icon:
                Icons.currency_rupee,

                title:
                'EMI Calculator',

                primaryTextColor:
                primaryTextColor,

                onTap:
                openEmiCalculator,
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(

        child: Padding(

          padding:
          EdgeInsets.symmetric(

            horizontal:
            horizontalPadding,

            vertical: 20,
          ),

          child: Column(

            children: [

              // TOP BAR

              Row(

                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

                children: [

                  Builder(

                    builder: (context) {

                      return IconButton(

                        onPressed: () {

                          Scaffold.of(
                            context,
                          ).openDrawer();
                        },

                        icon: Icon(

                          Icons.menu,

                          color:
                          primaryTextColor,

                          size: 28,
                        ),
                      );
                    },
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

                      color:
                      primaryTextColor,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: topGap,
              ),

              // DISPLAY

              Expanded(

                child: Column(

                  mainAxisAlignment:
                  MainAxisAlignment.end,

                  crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch,

                  children: [

                    AnimatedDefaultTextStyle(

                      duration:
                      const Duration(
                        milliseconds: 80,
                      ),

                      style: TextStyle(

                        fontSize:
                        isResultFinal
                            ? 28
                            : 48,

                        fontWeight:
                        isResultFinal
                            ? FontWeight.w400
                            : FontWeight.bold,

                        color:
                        isResultFinal
                            ? secondaryTextColor
                            : primaryTextColor,
                      ),

                      child: Text(

                        expression.isEmpty
                            ? '0'
                            : expression,

                        maxLines: 2,

                        overflow:
                        TextOverflow
                            .ellipsis,

                        textAlign:
                        TextAlign.right,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    AnimatedDefaultTextStyle(

                      duration:
                      const Duration(
                        milliseconds: 80,
                      ),

                      style: TextStyle(

                        fontSize:
                        isResultFinal
                            ? 58
                            : 30,

                        fontWeight:
                        isResultFinal
                            ? FontWeight.bold
                            : FontWeight.w400,

                        color:
                        isResultFinal
                            ? primaryTextColor
                            : secondaryTextColor,
                      ),

                      child: Text(

                        result,

                        maxLines: 1,

                        overflow:
                        TextOverflow
                            .ellipsis,

                        textAlign:
                        TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height:
                screenHeight * 0.02,
              ),

              // HISTORY BUTTON

              Align(

                alignment:
                Alignment.centerLeft,

                child: GestureDetector(

                  onTap:
                  openHistoryScreen,

                  child: Container(

                    padding:
                    const EdgeInsets.symmetric(

                      horizontal: 10,

                      vertical: 10,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      isDark
                          ? const Color(
                          0xFF1A2238)
                          : const Color(
                          0xFFF1F1F1),

                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),

                    child: Icon(

                      Icons.history,

                      size: 20,

                      color:
                      isDark
                          ? Colors.orange
                          : Colors.deepOrange,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height:
                screenHeight * 0.02,
              ),

              // BUTTON GRID

              Expanded(

                flex: 2,

                child: GridView.builder(

                  physics:
                  const NeverScrollableScrollPhysics(),

                  padding:
                  EdgeInsets.zero,

                  itemCount:
                  buttons.length,

                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 4,

                    crossAxisSpacing:
                    buttonSpacing,

                    mainAxisSpacing:
                    buttonSpacing,

                    childAspectRatio:
                    aspectRatio,
                  ),

                  itemBuilder:
                      (context, index) {

                    final String button =
                    buttons[index];

                    return CalcButton(

                      text: button,

                      color:
                      isOperator(button)

                          ? Colors.orange

                          : isDark

                          ? const Color(
                          0xFF1A2238)

                          : const Color(
                          0xFFF1F1F1),

                      onTap: () =>
                          onButtonClick(
                            button,
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}