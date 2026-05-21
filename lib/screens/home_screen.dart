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
          expression =
              expression.substring(0, expression.length - 1);

          if (expression.isEmpty) {
            result = "0";
          } else {
            result = calculate(expression);
          }
        }

        isResultFinal = false;
      }

      // EQUALS
      else if (value == '=') {
        result = calculate(expression);
        isResultFinal = true;
      }

      // NORMAL BUTTONS
      else {

        // If user starts typing after "="
        if (isResultFinal) {
          isResultFinal = false;
        }

        expression += value;

        // Live preview result
        result = calculate(expression);
      }
    });
  }

  bool isOperator(String x) {
    return ['%', '÷', '×', '-', '+', '='].contains(x);
  }

  @override
  Widget build(BuildContext context) {

    final bgColor =
    widget.isDark ? Colors.black : Colors.white;

    final primaryTextColor =
    widget.isDark ? Colors.white : Colors.black;

    final secondaryTextColor =
    widget.isDark ? Colors.grey.shade600 : Colors.grey.shade500;

    return Scaffold(
      backgroundColor: bgColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

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
                  ),

                  Text(
                    "Calculator",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),

                  IconButton(
                    onPressed: widget.toggleTheme,

                    icon: Icon(
                      widget.isDark
                          ? Icons.light_mode
                          : Icons.dark_mode,

                      color: primaryTextColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // EQUATION
              Align(
                alignment: Alignment.centerRight,

                child: Text(
                  expression.isEmpty ? "0" : expression,

                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(

                    // BEFORE "="
                    // Equation large + white

                    // AFTER "="
                    // Equation small + grey

                    fontSize:
                    isResultFinal ? 28 : 46,

                    fontWeight:
                    isResultFinal
                        ? FontWeight.w400
                        : FontWeight.bold,

                    color:
                    isResultFinal
                        ? secondaryTextColor
                        : primaryTextColor,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // RESULT
              Align(
                alignment: Alignment.centerRight,

                child: Text(
                  result,

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(

                    // BEFORE "="
                    // Result small + grey

                    // AFTER "="
                    // Result large + white

                    fontSize:
                    isResultFinal ? 56 : 28,

                    fontWeight:
                    isResultFinal
                        ? FontWeight.bold
                        : FontWeight.w400,

                    color:
                    isResultFinal
                        ? primaryTextColor
                        : secondaryTextColor,
                  ),
                ),
              ),

              const SizedBox(height: 130),

              // BUTTONS
              Expanded(
                flex: 2,

                child: GridView.builder(
                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount: buttons.length,

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.05,
                  ),

                  itemBuilder: (context, index) {

                    final button = buttons[index];

                    return CalcButton(

                      text: button,

                      color: isOperator(button)
                          ? Colors.orange
                          : widget.isDark
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFFF1F1F1),

                      onTap: () => onButtonClick(button),
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