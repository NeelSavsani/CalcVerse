import 'package:math_expressions/math_expressions.dart';

String calculate(String expression) {
  try {
    expression = expression.replaceAll('\u00d7', '*');
    expression = expression.replaceAll('\u00f7', '/');

    final Parser parser = Parser();
    final Expression parsedExpression = parser.parse(expression);
    final ContextModel contextModel = ContextModel();
    final double value =
        parsedExpression.evaluate(EvaluationType.REAL, contextModel);

    return value.toString();
  } catch (_) {
    return 'Error';
  }
}
