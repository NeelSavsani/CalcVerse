import 'package:flutter/material.dart';
import '../widgets/calc_button.dart';
import '../utils/calculator_logic.dart';
import 'history_screen.dart';

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

  // Tracks whether "=" was pressed
  bool isResultFinal = false;

  // HISTORY LIST
  List<String> history = [];

  final List<String> buttons = [

    'AC', '⌫', '%', '÷',

    '7', '8', '9', '×',

    '4', '5', '6', '-',

    '1', '2', '3', '+',

    '00', '0', '.', '='
  ];

  // CLEAR HISTORY
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
    ).then((_) {

      setState(() {});
    });
  }

  void onButtonClick(String value) {

    setState(() {

      // CLEAR
      if (value == 'AC') {

        expression = "";
        result = "0";
        isResultFinal = false;
      }

      // BACKSPACE
      else if (value == '⌫') {

        if (expression.isNotEmpty) {

          expression = expression.substring(
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

      // EQUALS
      else if (value == '=') {

        if (expression.isNotEmpty) {

          String lastChar =
          expression[
          expression.length - 1
          ];

          // Prevent "=" on incomplete equation
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

            // SAVE HISTORY
            history.add(
              "$expression = $result",
            );
          }
        }
      }

      // NORMAL BUTTONS
      else {

        // AFTER "=" BEHAVIOR
        if (isResultFinal) {

          // If user presses number,
          // start fresh calculation
          if (isNumberOrDot(value)) {

            expression = value;

            result =
            value == "."
                ? "0"
                : calculate(
              expression,
            );
          }

          // If user presses operator,
          // continue calculation
          else if (isOperator(value)) {

            expression =
                result + value;
          }

          isResultFinal = false;
        }

        // NORMAL INPUT FLOW
        else {

          expression += value;
        }

        String lastChar =
        expression[
        expression.length - 1
        ];

        // Prevent live calculation
        // if expression ends with operator
        if ([
          '+',
          '-',
          '×',
          '÷',
          '%'
        ].contains(lastChar)) {

          return;
        }

        // Live preview result
        result = calculate(expression);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // SCREEN SIZE
    double screenWidth =
        MediaQuery.of(context).size.width;

    double screenHeight =
        MediaQuery.of(context).size.height;

    // RESPONSIVE VALUES
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

    // COLORS
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

      body: SafeArea(

        child: Padding(

          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20,
          ),

          child: Column(

            children: [

              // TOP BAR
              Row(

                mainAxisAlignment:
                MainAxisAlignment.end,

                children: [

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

              // DISPLAY SECTION
              Expanded(

                child: Column(

                  mainAxisAlignment:
                  MainAxisAlignment.end,

                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,

                  children: [

                    // EQUATION
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

                    // RESULT
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

              // BUTTONS
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