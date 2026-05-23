import 'package:flutter/material.dart';
import '../widgets/calc_button.dart';
import '../utils/calculator_logic.dart';
import 'history_screen.dart';
import 'trigo_screen.dart';
import 'geo_screen.dart';

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

  String expression = "";
  String result = "0";

  bool isResultFinal = false;

  List<String> history = [];

  final List<String> buttons = [

    'AC', '⌫', '%', '÷',

    '7', '8', '9', '×',

    '4', '5', '6', '-',

    '1', '2', '3', '+',

    '00', '0', '.', '='
  ];

  void clearHistory() {

    setState(() {

      history.clear();
    });
  }

  bool isOperator(String x) {

    return [
      '%',
      '÷',
      '×',
      '-',
      '+',
      '='
    ].contains(x);
  }

  bool isNumberOrDot(String x) {

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
    ].contains(x);
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

  void onButtonClick(String value) {

    setState(() {

      if (value == 'AC') {

        expression = "";
        result = "0";
        isResultFinal = false;
      }

      else if (value == '⌫') {

        if (expression.isNotEmpty) {

          expression =
              expression.substring(
                0,
                expression.length - 1,
              );

          if (expression.isEmpty) {

            result = "0";

          } else {

            String lastChar =
            expression[
            expression.length - 1
            ];

            if (![
              '+',
              '-',
              '×',
              '÷',
              '%'
            ].contains(lastChar)) {

              result =
                  calculate(expression);
            }
          }
        }

        isResultFinal = false;
      }

      else if (value == '=') {

        if (expression.isNotEmpty) {

          String lastChar =
          expression[
          expression.length - 1
          ];

          if (![
            '+',
            '-',
            '×',
            '÷',
            '%'
          ].contains(lastChar)) {

            result =
                calculate(expression);

            isResultFinal = true;

            history.add(
              "$expression = $result",
            );
          }
        }
      }

      else {

        if (isResultFinal) {

          if (isNumberOrDot(value)) {

            expression = value;

            result =
            value == "."
                ? "0"
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

        String lastChar =
        expression[
        expression.length - 1
        ];

        if ([
          '+',
          '-',
          '×',
          '÷',
          '%'
        ].contains(lastChar)) {

          return;
        }

        result =
            calculate(expression);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth =
        MediaQuery.of(context).size.width;

    double screenHeight =
        MediaQuery.of(context).size.height;

    double horizontalPadding =
        screenWidth * 0.05;

    double topGap =
        screenHeight * 0.04;

    double buttonSpacing =
        screenWidth * 0.025;

    double aspectRatio =
    screenHeight < 700
        ? 1.02
        : 1.12;

    final bgColor =
    widget.isDark
        ? const Color(0xFF0D1326)
        : Colors.white;

    final primaryTextColor =
    widget.isDark
        ? Colors.white
        : Colors.black;

    final secondaryTextColor =
    widget.isDark
        ? const Color(0xFF7D8597)
        : Colors.grey.shade500;

    return Scaffold(

      backgroundColor: bgColor,

      drawer: Drawer(

        backgroundColor:
        widget.isDark
            ? const Color(0xFF0D1326)
            : Colors.white,

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

                  "CalcVerse",

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

              // BASIC CALCULATOR
              Container(

                color:
                widget.isDark
                    ? const Color(0xFF1A2238)
                    : Colors.grey.shade200,

                child: ListTile(

                  leading: Icon(

                    Icons.calculate,

                    color: Colors.orange,
                  ),

                  title: Text(

                    "Basic Calculator",

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

              // TRIGONOMETRY
              ListTile(

                leading: Icon(

                  Icons.functions,

                  color:
                  widget.isDark
                      ? Colors.orange
                      : Colors.deepOrange,
                ),

                title: Text(

                  "Trigonometry",

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight:
                    FontWeight.w500,

                    color:
                    primaryTextColor,
                  ),
                ),

                onTap: () {

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
                },
              ),

              // GEOMETRY
              ListTile(

                leading: Icon(

                  Icons.hexagon_outlined,

                  color:
                  widget.isDark
                      ? Colors.orange
                      : Colors.deepOrange,
                ),

                title: Text(

                  "Geometry",

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight:
                    FontWeight.w500,

                    color:
                    primaryTextColor,
                  ),
                ),

                onTap: () {

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
                },
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(

        child: Padding(

          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20,
          ),

          child: Column(

            children: [

              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  Builder(

                    builder: (context) {

                      return GestureDetector(

                        onTap: () {

                          Scaffold.of(context)
                              .openDrawer();
                        },

                        child: Icon(

                          Icons.menu,

                          color:
                          primaryTextColor,

                          size: 28,
                        ),
                      );
                    },
                  ),

                  IconButton(

                    onPressed:
                    widget.toggleTheme,

                    icon: Icon(

                      widget.isDark
                          ? Icons.light_mode
                          : Icons.dark_mode,

                      color:
                      primaryTextColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: topGap),

              Expanded(

                child: Column(

                  mainAxisAlignment:
                  MainAxisAlignment.end,

                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,

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
                            ? "0"
                            : expression,

                        maxLines: 2,

                        overflow:
                        TextOverflow.ellipsis,

                        textAlign:
                        TextAlign.right,
                      ),
                    ),

                    const SizedBox(height: 10),

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
                        TextOverflow.ellipsis,

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

                    decoration: BoxDecoration(

                      color:
                      widget.isDark
                          ? const Color(
                          0xFF1A2238)
                          : const Color(
                          0xFFF1F1F1),

                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),

                    child: Row(

                      mainAxisSize:
                      MainAxisSize.min,

                      children: [

                        Icon(

                          Icons.history,

                          size: 20,

                          color:
                          widget.isDark
                              ? Colors.orange
                              : Colors.deepOrange,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height:
                screenHeight * 0.02,
              ),

              Expanded(

                flex: 2,

                child: GridView.builder(

                  physics:
                  const NeverScrollableScrollPhysics(),

                  padding: EdgeInsets.zero,

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

                    final button =
                    buttons[index];

                    return CalcButton(

                      text: button,

                      color:
                      isOperator(button)

                          ? Colors.orange

                          : widget.isDark

                          ? const Color(
                          0xFF1A2238)

                          : const Color(
                          0xFFF1F1F1),

                      onTap:
                          () => onButtonClick(
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