import 'dart:math';

import 'package:flutter/material.dart';

import 'geo_screen.dart';
import 'home_screen.dart';
import 'trigo_screen.dart';

class EmiScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback toggleTheme;

  const EmiScreen({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<EmiScreen> createState() => _EmiScreenState();
}

class _EmiScreenState extends State<EmiScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController principalController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();

  String monthlyEmi = '-';
  String totalAmount = '-';
  String totalInterest = '-';
  bool showResult = false;

  @override
  void dispose() {
    principalController.dispose();
    rateController.dispose();
    tenureController.dispose();
    super.dispose();
  }

  void clearAll() {
    principalController.clear();
    rateController.clear();
    tenureController.clear();

    setState(() {
      monthlyEmi = '-';
      totalAmount = '-';
      totalInterest = '-';
      showResult = false;
    });
  }

  String formatValue(double value) {
    return value
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  void calculateEMI() {
    FocusScope.of(context).unfocus();

    final double principal = double.tryParse(principalController.text) ?? 0;
    final double annualRate = double.tryParse(rateController.text) ?? 0;
    final double months = double.tryParse(tenureController.text) ?? 0;

    if (principal <= 0 || annualRate <= 0 || months <= 0) {
      setState(() {
        showResult = false;
      });
      return;
    }

    final double monthlyRate = annualRate / 12 / 100;
    final double compound = pow(1 + monthlyRate, months).toDouble();
    final double emi = principal * monthlyRate * compound / (compound - 1);
    final double total = emi * months;
    final double interest = total - principal;

    setState(() {
      monthlyEmi = '\u20b9 ${formatValue(emi)}';
      totalAmount = '\u20b9 ${formatValue(total)}';
      totalInterest = '\u20b9 ${formatValue(interest)}';
      showResult = true;
    });
  }

  void openBasicCalculator() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          isDark: widget.isDark,
          toggleTheme: widget.toggleTheme,
        ),
      ),
    );
  }

  void openTrigonometry() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TrigoScreen(
          isDark: widget.isDark,
          toggleTheme: widget.toggleTheme,
        ),
      ),
    );
  }

  void openGeometry() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GeoScreen(
          isDark: widget.isDark,
          toggleTheme: widget.toggleTheme,
        ),
      ),
    );
  }

  Widget buildInput({
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

  Widget buildResultCard({
    required String title,
    required String value,
    required Color cardColor,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: secondaryText,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItem({
    required IconData icon,
    required String title,
    required Color primaryText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.orange,
      ),
      title: Text(
        title,
        style: TextStyle(color: primaryText),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF0D1326) : Colors.white;
    final Color cardColor =
        isDark ? const Color(0xFF1A2238) : const Color(0xFFF4F4F4);
    final Color primaryText = isDark ? Colors.white : Colors.black;
    final Color secondaryText =
        isDark ? Colors.grey.shade400 : Colors.grey.shade700;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: bgColor,
      drawer: Drawer(
        backgroundColor: bgColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'CalcVerse',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              buildDrawerItem(
                icon: Icons.calculate,
                title: 'Basic Calculator',
                primaryText: primaryText,
                onTap: openBasicCalculator,
              ),
              buildDrawerItem(
                icon: Icons.functions,
                title: 'Trigonometry',
                primaryText: primaryText,
                onTap: openTrigonometry,
              ),
              buildDrawerItem(
                icon: Icons.hexagon_outlined,
                title: 'Geometry',
                primaryText: primaryText,
                onTap: openGeometry,
              ),
              Container(
                color: isDark ? const Color(0xFF1A2238) : Colors.grey.shade200,
                child: ListTile(
                  leading: const Icon(
                    Icons.currency_rupee,
                    color: Colors.orange,
                  ),
                  title: Text(
                    'EMI Calculator',
                    style: TextStyle(
                      color: primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
              icon: Icon(
                Icons.menu,
                color: primaryText,
              ),
            ),
            Text(
              'EMI Calculator',
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: widget.toggleTheme,
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
              buildInput(
                label: 'Principal Amount (\u20b9)',
                hint: 'e.g. 500000',
                controller: principalController,
                cardColor: cardColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
              const SizedBox(height: 20),
              buildInput(
                label: 'Annual Interest Rate (%)',
                hint: 'e.g. 8.5',
                controller: rateController,
                cardColor: cardColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
              const SizedBox(height: 20),
              buildInput(
                label: 'Tenure (Months)',
                hint: 'e.g. 60',
                controller: tenureController,
                cardColor: cardColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 58,
                      child: ElevatedButton(
                        onPressed: calculateEMI,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Calculate EMI',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 58,
                    child: ElevatedButton(
                      onPressed: clearAll,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                      ),
                      child: const Text(
                        'AC',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (showResult) ...[
                buildResultCard(
                  title: 'Monthly EMI',
                  value: monthlyEmi,
                  cardColor: cardColor,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),
                const SizedBox(height: 16),
                buildResultCard(
                  title: 'Total Amount',
                  value: totalAmount,
                  cardColor: cardColor,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),
                const SizedBox(height: 16),
                buildResultCard(
                  title: 'Total Interest',
                  value: totalInterest,
                  cardColor: cardColor,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
