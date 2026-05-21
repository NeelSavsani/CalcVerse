import 'package:math_expressions/math_expressions.dart';

String calculate(String expression) {
  try {
    expression = expression.replaceAll('×', '*');
    expression = expression.replaceAll('÷', '/');

    Parser p = Parser();
    Expression exp = p.parse(expression);

    ContextModel cm = ContextModel();

    double eval = exp.evaluate(EvaluationType.REAL, cm);

    return eval.toString();
  } catch (e) {
    return "Error";
  }
}