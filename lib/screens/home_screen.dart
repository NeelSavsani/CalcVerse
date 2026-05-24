import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../utils/calculator_logic.dart';
import '../widgets/calc_button.dart';

import 'history_screen.dart';

class HomeScreen extends StatefulWidget {

  final bool isDark;
  final VoidCallback toggleTheme;
//test
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

  bool? isEqualPressed = false;

  final List<String> history = [];

  final List<List<String>> buttonRows = const [

    [
      'AC',
      backspace,
      '(',
      ')',
    ],

    [
      '^',
      '%',
      divide,
      multiply,
    ],

    [
      '7',
      '8',
      '9',
      '-',
    ],

    [
      '4',
      '5',
      '6',
      '+',
    ],
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
      '^',
      '-',
      '+',
      '='
    ].contains(value);
  }

  bool isMathOperator(String value) {

    return [
      '%',
      divide,
      multiply,
      '^',
      '-',
      '+',
    ].contains(value);
  }

  bool isParenthesis(String value) {

    return [
      '(',
      ')',
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
      '^',
      '%'

    ].contains(lastChar);
  }

  String formatResult(
      String value,
      ) {

    if (value.contains('.')) {

      double? number =
      double.tryParse(value);

      if (number != null &&
          number == number.toInt()) {

        return number
            .toInt()
            .toString();
      }
    }

    return value;
  }

  String lastInput(String value) {

    return value[value.length - 1];
  }

  int openParenthesesCount(
      String value,
      ) {

    int count = 0;

    for (final String char
    in value.split('')) {

      if (char == '(') {

        count++;
      }

      else if (char == ')') {

        count--;
      }
    }

    return count;
  }

  bool hasBalancedParentheses(
      String value,
      ) {

    return openParenthesesCount(
      value,
    ) == 0;
  }

  bool canCalculateExpression(
      String value,
      ) {

    if (value.isEmpty ||
        endsWithOperator(
          value,
        )) {

      return false;
    }

    final String lastChar =
        lastInput(value);

    return lastChar != '(' &&
        lastChar != '.' &&
        hasBalancedParentheses(
          value,
        );
  }

  bool hasDotInCurrentNumber() {

    for (int i = expression.length - 1;
    i >= 0;
    i--) {

      final String char =
          expression[i];

      if (char == '.') {

        return true;
      }

      if (isMathOperator(char) ||
          isParenthesis(char)) {

        return false;
      }
    }

    return false;
  }

  void updateResultPreview() {

    if (canCalculateExpression(
      expression,
    )) {

      result = formatResult(
        calculate(
          expression,
        ),
      );
    }

    else {

      result = '0';
    }
  }

  Color buttonColor(
      String button,
      bool isDark,
      ) {

    if (isOperator(button) ||
        isParenthesis(button)) {

      return Colors.orange;
    }

    return isDark
        ? const Color(0xFF1A2238)
        : const Color(0xFFF1F1F1);
  }

  Widget buildWideButton({
    required String text,
    required bool isDark,
    required double normalButtonSize,
  }) {

    final Color color =
        buttonColor(
          text,
          isDark,
        );

    final bool isLightButton =
        color == const Color(0xFFF1F1F1);

    final Color pressedColor =
    isLightButton
        ? Colors.grey.shade300
        : color.withOpacity(0.75);

    final bool equalPressed =
        isEqualPressed ?? false;

    return LayoutBuilder(

      builder: (context, constraints) {

        final double buttonWidth =
            constraints.maxWidth < normalButtonSize
                ? constraints.maxWidth
                : normalButtonSize;

        return Center(

          child: SizedBox(

            width:
            buttonWidth,

            height:
            constraints.maxHeight,

            child: GestureDetector(

              onTapDown: (_) {

                setState(() {

                  isEqualPressed = true;
                });
              },

              onTapUp: (_) {

                setState(() {

                  isEqualPressed = false;
                });

                onButtonClick(
                  text,
                );
              },

              onTapCancel: () {

                setState(() {

                  isEqualPressed = false;
                });
              },

              child: AnimatedContainer(

                duration:
                const Duration(
                  milliseconds: 80,
                ),

                curve:
                Curves.easeOut,

                transformAlignment:
                Alignment.center,

                transform:
                Matrix4.identity()
                  ..scale(
                    equalPressed
                        ? 0.88
                        : 1.0,
                  ),

                decoration: BoxDecoration(

                  color:
                  equalPressed
                      ? pressedColor
                      : color,

                  borderRadius:
                  BorderRadius.circular(
                    buttonWidth / 2,
                  ),

                  boxShadow: [

                    BoxShadow(

                      color:
                      Colors.black.withOpacity(
                        equalPressed
                            ? 0.05
                            : 0.12,
                      ),

                      blurRadius:
                      equalPressed
                          ? 3
                          : 8,

                      offset: Offset(
                        0,
                        equalPressed
                            ? 2
                            : 4,
                      ),
                    ),
                  ],
                ),

                child: Center(

                  child: AnimatedScale(

                    duration:
                    const Duration(
                      milliseconds: 80,
                    ),

                    scale:
                    equalPressed
                        ? 0.92
                        : 1.0,

                    child: Text(

                      text,

                      style: TextStyle(

                        fontSize: 32,

                        fontWeight:
                        FontWeight.w500,

                        color:
                        isLightButton
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
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

          updateResultPreview();
        }

        isResultFinal = false;

        return;
      }

      if (value == '=') {

        if (isResultFinal) {

          return;
        }

        if (canCalculateExpression(
              expression,
            )) {

          result =
              formatResult(
                calculate(
                  expression,
                ),
              );

          isResultFinal = true;

          history.add(
            '$expression = $result',
          );
        }

        return;
      }

      if (isMathOperator(value)) {

        if (expression.isEmpty) {

          if (value == '-') {

            expression = value;
          }

          isResultFinal = false;

          return;
        }

        if (endsWithOperator(
          expression,
        )) {

          if (expression.length == 1 ||
              expression[expression.length - 2] == '(') {

            return;
          }

          expression =
              expression.substring(
                0,
                expression.length - 1,
              ) + value;

          isResultFinal = false;

          return;
        }

        if (lastInput(
              expression,
            ) == '(' &&
            value != '-') {

          return;
        }
      }

      if (value == '(') {

        if (isResultFinal) {

          expression = value;

          result = '0';

          isResultFinal = false;

          return;
        }

        if (expression.isEmpty ||
            endsWithOperator(
              expression,
            ) ||
            lastInput(
              expression,
            ) == '(') {

          expression += value;
        }

        else {

          expression += multiply + value;
        }

        updateResultPreview();

        return;
      }

      if (value == ')') {

        if (expression.isEmpty ||
            openParenthesesCount(
              expression,
            ) <= 0 ||
            endsWithOperator(
              expression,
            ) ||
            lastInput(
              expression,
            ) == '(' ||
            lastInput(
              expression,
            ) == '.') {

          return;
        }

        expression += value;

        updateResultPreview();

        isResultFinal = false;

        return;
      }

      if (value == '.' &&
          hasDotInCurrentNumber()) {

        return;
      }

      if (isResultFinal) {

        if (isNumberOrDot(value)) {

          expression = value;

          result =
          value == '.'
              ? '0'
              : formatResult(
            calculate(
              expression,
            ),
          );
        }

        else if (isOperator(value)) {

          expression =
              result + value;
        }

        isResultFinal = false;
      }

      else {

        if (isNumberOrDot(value) &&
            expression.isNotEmpty &&
            lastInput(
              expression,
            ) == ')') {

          expression += multiply + value;
        }

        else {

          expression += value;
        }
      }

      if (canCalculateExpression(
        expression,
      )) {

        result = formatResult(
          calculate(
            expression,
          ),
        );
      }
    });
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

      resizeToAvoidBottomInset:
      false,

      backgroundColor:
      bgColor,

      drawer: const AppDrawer(

        currentRoute:
        AppDrawer.basicCalculatorRoute,
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

                          FocusManager.instance
                              .primaryFocus
                              ?.unfocus();

                          Future.delayed(

                            const Duration(
                              milliseconds: 100,
                            ),

                                () {

                              Scaffold.of(
                                context,
                              ).openDrawer();
                            },
                          );
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

                child: LayoutBuilder(

                  builder: (context, constraints) {

                    const int columnCount = 4;
                    const int rowCount = 6;

                    final double buttonWidth =
                        (constraints.maxWidth -
                            (buttonSpacing *
                                (columnCount - 1))) /
                            columnCount;

                    final double buttonHeight =
                        (constraints.maxHeight -
                            (buttonSpacing *
                                (rowCount - 1))) /
                            rowCount;

                    Widget normalButton(
                        String button,
                        ) {

                      return SizedBox(

                        width:
                        buttonWidth,

                        height:
                        buttonHeight,

                        child: CalcButton(

                          text:
                          button,

                          color:
                          buttonColor(
                            button,
                            isDark,
                          ),

                          onTap: () =>
                              onButtonClick(
                                button,
                              ),
                        ),
                      );
                    }

                    Widget buttonRow(
                        List<String> row,
                        ) {

                      return SizedBox(

                        height:
                        buttonHeight,

                        child: Row(

                          children: [

                            for (int i = 0;
                            i < row.length;
                            i++) ...[

                              normalButton(
                                row[i],
                              ),

                              if (i != row.length - 1)
                                SizedBox(
                                  width: buttonSpacing,
                                ),
                            ],
                          ],
                        ),
                      );
                    }

                    return Column(

                      children: [

                        for (final List<String> row
                        in buttonRows) ...[

                          buttonRow(
                            row,
                          ),

                          SizedBox(
                            height:
                            buttonSpacing,
                          ),
                        ],

                        SizedBox(

                          height:
                          (buttonHeight * 2) +
                              buttonSpacing,

                          child: Row(

                            crossAxisAlignment:
                            CrossAxisAlignment
                                .stretch,

                            children: [

                              SizedBox(

                                width:
                                (buttonWidth * 3) +
                                    (buttonSpacing * 2),

                                child: Column(

                                  children: [

                                    buttonRow(
                                      const [
                                        '1',
                                        '2',
                                        '3',
                                      ],
                                    ),

                                    SizedBox(
                                      height:
                                      buttonSpacing,
                                    ),

                                    buttonRow(
                                      const [
                                        '00',
                                        '0',
                                        '.',
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                width:
                                buttonSpacing,
                              ),

                              SizedBox(

                                width:
                                buttonWidth,

                                child: buildWideButton(
                                  text: '=',
                                  isDark: isDark,
                                  normalButtonSize:
                                  buttonHeight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
