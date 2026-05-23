import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class BmiScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback toggleTheme;

  const BmiScreen({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String gender = 'Male';
  String heightUnit = 'cm';
  String weightUnit = 'kg';

  bool showResult = false;
  double bmi = 0;
  String bmiStatus = '';
  Color bmiColor = Colors.green;

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void clearAll() {
    FocusScope.of(context).unfocus();

    heightController.clear();
    weightController.clear();
    ageController.clear();

    setState(() {
      gender = 'Male';
      heightUnit = 'cm';
      weightUnit = 'kg';
      bmi = 0;
      bmiStatus = '';
      bmiColor = Colors.green;
      showResult = false;
    });
  }

  void calculateBMI() {
    FocusScope.of(context).unfocus();

    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;

    if (height <= 0 || weight <= 0) {
      return;
    }

    double heightInMeters = height;

    if (heightUnit == 'cm') {
      heightInMeters = height / 100;
    } else if (heightUnit == 'inch') {
      heightInMeters = height * 0.0254;
    } else if (heightUnit == 'ft') {
      heightInMeters = height * 0.3048;
    }

    double weightInKg = weight;
    if (weightUnit == 'lbs') {
      weightInKg = weight * 0.453592;
    }

    bmi = weightInKg / (heightInMeters * heightInMeters);

    if (bmi < 18.5) {
      bmiStatus = 'Underweight';
      bmiColor = Colors.orange;
    } else if (bmi < 25) {
      bmiStatus = 'Normal';
      bmiColor = Colors.green;
    } else if (bmi < 30) {
      bmiStatus = 'Overweight';
      bmiColor = Colors.amber;
    } else {
      bmiStatus = 'Obese';
      bmiColor = Colors.red;
    }

    setState(() {
      showResult = true;
    });
  }

  Widget buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Color cardColor,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: secondaryText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              color: primaryText,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: secondaryText),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final Color bgColor =
    isDark ? const Color(0xFF0D1326) : Colors.white;

    final Color cardColor =
    isDark ? const Color(0xFF1A2238) : const Color(0xFFF4F4F4);

    final Color primaryText =
    isDark ? Colors.white : Colors.black;

    final Color secondaryText =
    isDark ? Colors.grey.shade400 : Colors.grey.shade700;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: bgColor,
      drawer: const AppDrawer(
        currentRoute: AppDrawer.bmiRoute,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
              "BMI Calculator",
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                widget.toggleTheme();
                Future.delayed(
                  const Duration(milliseconds: 50),
                      () {
                    if (mounted) {
                      setState(() {});
                    }
                  },
                );
              },
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: primaryText,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Gender",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: secondaryText,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      value: 'Male',
                      groupValue: gender,
                      activeColor: Colors.orange,
                      title: Text(
                        'Male',
                        style: TextStyle(color: primaryText),
                      ),
                      onChanged: (value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      value: 'Female',
                      groupValue: gender,
                      activeColor: Colors.orange,
                      title: Text(
                        'Female',
                        style: TextStyle(color: primaryText),
                      ),
                      onChanged: (value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: buildInputField(
                      label: "Height",
                      hint: "Enter height",
                      controller: heightController,
                      cardColor: cardColor,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Unit",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: secondaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: heightUnit,
                              dropdownColor: cardColor,
                              isExpanded: true,
                              style: TextStyle(color: primaryText),
                              items: ['cm', 'ft', 'inch'].map((unit) {
                                return DropdownMenuItem(
                                  value: unit,
                                  child: Text(unit),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  heightUnit = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: buildInputField(
                      label: "Weight",
                      hint: "Enter weight",
                      controller: weightController,
                      cardColor: cardColor,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Unit",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: secondaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: weightUnit,
                              dropdownColor: cardColor,
                              isExpanded: true,
                              style: TextStyle(color: primaryText),
                              items: ['kg', 'lbs'].map((unit) {
                                return DropdownMenuItem(
                                  value: unit,
                                  child: Text(unit),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  weightUnit = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildInputField(
                label: "Age",
                hint: "Enter age",
                controller: ageController,
                cardColor: cardColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: calculateBMI,
                      child: Container(
                        height: 58,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text(
                          "Calculate",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text(
                        "AC",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (showResult)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Your BMI",
                        style: TextStyle(
                          fontSize: 16,
                          color: secondaryText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: BMIPainter(bmi: bmi),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              child: Column(
                                children: [
                                  Text(
                                    bmi.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 46,
                                      fontWeight: FontWeight.bold,
                                      color: bmiColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    bmiStatus,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: bmiColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

class BMIPainter extends CustomPainter {
  final double bmi;

  BMIPainter({
    required this.bmi,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(
      size.width / 2,
      size.height * 0.78,
    );

    final double radius = size.width * 0.34;
    final double strokeWidth = 24;

    final Rect rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    paint.color = Colors.orange;
    canvas.drawArc(rect, pi, pi * 0.25, false, paint);

    paint.color = Colors.green;
    canvas.drawArc(rect, pi * 1.25, pi * 0.25, false, paint);

    paint.color = Colors.amber;
    canvas.drawArc(rect, pi * 1.5, pi * 0.20, false, paint);

    paint.color = Colors.red;
    canvas.drawArc(rect, pi * 1.70, pi * 0.30, false, paint);

    final double safeBMI = bmi.clamp(10, 40);
    final double progress = (safeBMI - 10) / 30;
    final double angle = pi + (progress * pi);

    final double needleRadius = radius - 20;

    final Offset needleEnd = Offset(
      center.dx + needleRadius * cos(angle),
      center.dy + needleRadius * sin(angle),
    );

    final Paint needlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);

    canvas.drawCircle(
      center,
      7,
      Paint()..color = Colors.grey,
    );
  }

  @override
  bool shouldRepaint(covariant BMIPainter oldDelegate) {
    return oldDelegate.bmi != bmi;
  }
}