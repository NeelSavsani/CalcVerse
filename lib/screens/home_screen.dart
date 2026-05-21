import 'package:flutter/material.dart';
import '../widgets/calc_button.dart';
import '../utils/calculator_logic.dart';

class HomeScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback toggleTheme;

  const HomeScreen({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String expression = "";
  String result = "0";

  // Tracks whether "=" was pressed
  bool isResultFinal = false;

  final List<String> buttons = [

    'AC', '⌫', '%', '÷',

    '7', '8', '9', '×',

    '4', '5', '6', '-',

    '1', '2', '3', '+',

    '00', '0', '.', '='
  ];

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

            // Prevent error for incomplete expression
            String lastChar =
            expression[expression.length - 1];

            if (![
              '+',
              '-',
              '×',
              '÷',
              '%'
            ].contains(lastChar)) {

              result = calculate(expression);
            }
          }
        }

        isResultFinal = false;
      }

      // EQUALS
      else if (value == '=') {

        if (expression.isNotEmpty) {

          String lastChar =
          expression[expression.length - 1];

          // Prevent "=" on incomplete equation
          if (![
            '+',
            '-',
            '×',
            '÷',
            '%'
          ].contains(lastChar)) {

            result = calculate(expression);

            isResultFinal = true;
          }
        }
      }

      // NORMAL BUTTONS
      else {

        // If user starts typing again after "="
        if (isResultFinal) {

          isResultFinal = false;
        }

        expression += value;

        String lastChar =
        expression[expression.length - 1];

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
        screenHeight * 0.06;

    double buttonSpacing =
        screenWidth * 0.025;

    double aspectRatio =
    screenHeight < 700 ? 1.02 : 1.12;

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
                MainAxisAlignment.spaceBetween,

                children: [

                  Icon(
                    Icons.menu,
                    color: primaryTextColor,
                    size: 28,
                  ),

                  IconButton(

                    onPressed:
                    widget.toggleTheme,

                    icon: Icon(

                      widget.isDark
                          ? Icons.light_mode
                          : Icons.dark_mode,

                      color: primaryTextColor,
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

                        // BEFORE "="
                        // Equation large + white

                        // AFTER "="
                        // Equation small + grey

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

                        // BEFORE "="
                        // Result small + grey

                        // AFTER "="
                        // Result large + white

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
                screenHeight * 0.03,
              ),

              // BUTTONS
              Expanded(

                flex: 2,

                child: GridView.builder(

                  physics:
                  const NeverScrollableScrollPhysics(),

                  padding: EdgeInsets.zero,

                  itemCount: buttons.length,

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

                          ? const Color(0xFF1A2238)

                          : const Color(0xFFF1F1F1),

                      onTap:
                          () => onButtonClick(button),
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