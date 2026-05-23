import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class GstScreen extends StatefulWidget {

  final bool isDark;
  final VoidCallback toggleTheme;

  const GstScreen({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<GstScreen> createState() =>
      _GstScreenState();
}

class _GstScreenState
    extends State<GstScreen> {

  final GlobalKey<ScaffoldState>
  scaffoldKey =
  GlobalKey<ScaffoldState>();

  final TextEditingController
  amountController =
  TextEditingController();

  final TextEditingController
  customRateController =
  TextEditingController();

  String gstMode = "add";

  String selectedRate = "5";

  bool showCustomRate = false;

  bool showResult = false;

  Map<String, String> summary = {};

  String cgstPct = "";
  String sgstPct = "";
  String igstPct = "";

  String cgstAmt = "";
  String sgstAmt = "";
  String igstAmt = "";

  void clearAll() {

    amountController.clear();

    customRateController.clear();

    setState(() {

      selectedRate = "5";

      gstMode = "add";

      showCustomRate = false;

      showResult = false;

      summary.clear();

      cgstPct = "";
      sgstPct = "";
      igstPct = "";

      cgstAmt = "";
      sgstAmt = "";
      igstAmt = "";
    });
  }

  String formatCurrency(
      double value,
      ) {

    return "₹ ${value.toStringAsFixed(2)}";
  }

  void calculateGST() {

    FocusScope.of(context).unfocus();

    double amount =
        double.tryParse(
          amountController.text,
        ) ??
            0;

    double rate =
    selectedRate == "custom"

        ? double.tryParse(
      customRateController.text,
    ) ??
        0

        : double.parse(
      selectedRate,
    );

    if (amount <= 0 ||
        rate < 0) {

      setState(() {

        showResult = false;
      });

      return;
    }

    double originalAmt;

    double gstAmt;

    double totalAmt;

    if (gstMode == "add") {

      originalAmt = amount;

      gstAmt =
          (amount * rate) / 100;

      totalAmt =
          amount + gstAmt;
    }

    else {

      totalAmt = amount;

      originalAmt =
          (amount * 100) /
              (100 + rate);

      gstAmt =
          totalAmt -
              originalAmt;
    }

    double half = rate / 2;

    setState(() {

      summary = {

        "Original Amount":
        formatCurrency(
          originalAmt,
        ),

        "GST Amount ($rate%)":
        formatCurrency(
          gstAmt,
        ),

        "Total Amount":
        formatCurrency(
          totalAmt,
        ),
      };

      cgstPct = "$half%";

      sgstPct = "$half%";

      igstPct = "$rate%";

      cgstAmt =
          formatCurrency(
            gstAmt / 2,
          );

      sgstAmt =
          formatCurrency(
            gstAmt / 2,
          );

      igstAmt =
          formatCurrency(
            gstAmt,
          );

      showResult = true;
    });
  }

  Widget buildInput(
      String label,
      String hint,
      TextEditingController controller,
      Color cardColor,
      Color primaryText,
      Color secondaryText,
      ) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(

          label,

          style: TextStyle(

            fontSize: 15,

            fontWeight:
            FontWeight.w500,

            color:
            secondaryText,
          ),
        ),

        const SizedBox(height: 8),

        Container(

          decoration: BoxDecoration(

            color: cardColor,

            borderRadius:
            BorderRadius.circular(
              18,
            ),
          ),

          child: TextField(

            controller: controller,

            keyboardType:
            const TextInputType
                .numberWithOptions(
              decimal: true,
            ),

            style: TextStyle(

              color: primaryText,

              fontSize: 18,
            ),

            decoration:
            InputDecoration(

              hintText: hint,

              hintStyle: TextStyle(

                color:
                secondaryText,
              ),

              border:
              InputBorder.none,

              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildResultCard(
      String title,
      String value,
      Color cardColor,
      Color primaryText,
      Color secondaryText,
      ) {

    return Container(

      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: cardColor,

        borderRadius:
        BorderRadius.circular(
          22,
        ),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style: TextStyle(

              fontSize: 15,

              color:
              secondaryText,
            ),
          ),

          const SizedBox(height: 10),

          Text(

            value,

            style: TextStyle(

              fontSize: 28,

              fontWeight:
              FontWeight.bold,

              color:
              primaryText,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final Color bgColor =
    isDark
        ? const Color(0xFF0D1326)
        : Colors.white;

    final Color cardColor =
    isDark
        ? const Color(0xFF1A2238)
        : const Color(0xFFF4F4F4);

    final Color primaryText =
    isDark
        ? Colors.white
        : Colors.black;

    final Color secondaryText =
    isDark
        ? Colors.grey.shade400
        : Colors.grey.shade700;

    return Scaffold(

      resizeToAvoidBottomInset: false,

      key: scaffoldKey,

      backgroundColor: bgColor,

      drawer: const AppDrawer(
        currentRoute: '/gst',
      ),

      appBar: AppBar(

        elevation: 0,

        backgroundColor: bgColor,

        automaticallyImplyLeading: false,

        title: Row(

          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

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

              "GST Calculator",

              style: TextStyle(

                color: primaryText,

                fontWeight:
                FontWeight.bold,
              ),
            ),

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

                color: primaryText,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // MODE TOGGLE

              Row(

                children: [

                  Expanded(

                    child: GestureDetector(

                      onTap: () {

                        setState(() {

                          gstMode = "add";
                        });

                        calculateGST();
                      },

                      child: Container(

                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 16,
                        ),

                        alignment:
                        Alignment.center,

                        decoration:
                        BoxDecoration(

                          color:
                          gstMode == "add"

                              ? Colors.orange

                              : cardColor,

                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),

                        child: Text(

                          "Add GST",

                          style: TextStyle(

                            fontSize: 16,

                            fontWeight:
                            FontWeight.bold,

                            color:
                            gstMode == "add"

                                ? Colors.white

                                : primaryText,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(

                    child: GestureDetector(

                      onTap: () {

                        setState(() {

                          gstMode =
                          "remove";
                        });

                        calculateGST();
                      },

                      child: Container(

                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 16,
                        ),

                        alignment:
                        Alignment.center,

                        decoration:
                        BoxDecoration(

                          color:
                          gstMode ==
                              "remove"

                              ? Colors.orange

                              : cardColor,

                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),

                        child: Text(

                          "Remove GST",

                          style: TextStyle(

                            fontSize: 16,

                            fontWeight:
                            FontWeight.bold,

                            color:
                            gstMode ==
                                "remove"

                                ? Colors.white

                                : primaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              buildInput(

                gstMode == "add"

                    ? "Original Amount (₹)"

                    : "Amount with GST (₹)",

                "e.g. 10000",

                amountController,

                cardColor,

                primaryText,

                secondaryText,
              ),

              const SizedBox(height: 20),

              // GST RATE

              Text(

                "GST Rate (%)",

                style: TextStyle(

                  fontSize: 15,

                  fontWeight:
                  FontWeight.w500,

                  color:
                  secondaryText,
                ),
              ),

              const SizedBox(height: 8),

              Container(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 18,
                ),

                decoration: BoxDecoration(

                  color: cardColor,

                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),

                child: DropdownButtonHideUnderline(

                  child: DropdownButton<String>(

                    value: selectedRate,

                    dropdownColor:
                    cardColor,

                    isExpanded: true,

                    style: TextStyle(
                      color: primaryText,
                    ),

                    items: [

                      "0",
                      "0.1",
                      "0.25",
                      "1",
                      "1.5",
                      "3",
                      "5",
                      "6",
                      "7.5",
                      "12",
                      "18",
                      "28",
                      "custom"

                    ].map((rate) {

                      return DropdownMenuItem(

                        value: rate,

                        child: Text(

                          rate == "custom"

                              ? "Custom"

                              : "$rate%",
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {

                      setState(() {

                        selectedRate =
                        value!;

                        showCustomRate =
                            value ==
                                "custom";
                      });

                      calculateGST();
                    },
                  ),
                ),
              ),

              if (showCustomRate) ...[

                const SizedBox(height: 20),

                buildInput(

                  "Custom GST Rate (%)",

                  "e.g. 15",

                  customRateController,

                  cardColor,

                  primaryText,

                  secondaryText,
                ),
              ],

              const SizedBox(height: 28),

              // BUTTONS

              Row(

                children: [

                  Expanded(

                    child: GestureDetector(

                      onTap:
                      calculateGST,

                      child: Container(

                        height: 58,

                        alignment:
                        Alignment.center,

                        decoration:
                        BoxDecoration(

                          color:
                          Colors.orange,

                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),

                        child: const Text(

                          "Calculate GST",

                          style: TextStyle(

                            fontSize: 18,

                            fontWeight:
                            FontWeight.bold,

                            color:
                            Colors.white,
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

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 22,
                      ),

                      alignment:
                      Alignment.center,

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.red,

                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                      ),

                      child: const Text(

                        "AC",

                        style: TextStyle(

                          fontSize: 18,

                          fontWeight:
                          FontWeight.bold,

                          color:
                          Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              if (showResult) ...[

                ...summary.entries.map(

                      (entry) => Padding(

                    padding:
                    const EdgeInsets.only(
                      bottom: 16,
                    ),

                    child: buildResultCard(

                      entry.key,

                      entry.value,

                      cardColor,

                      primaryText,

                      secondaryText,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                buildResultCard(

                  "CGST ($cgstPct)",

                  cgstAmt,

                  cardColor,

                  primaryText,

                  secondaryText,
                ),

                const SizedBox(height: 16),

                buildResultCard(

                  "SGST ($sgstPct)",

                  sgstAmt,

                  cardColor,

                  primaryText,

                  secondaryText,
                ),

                const SizedBox(height: 16),

                buildResultCard(

                  "IGST ($igstPct)",

                  igstAmt,

                  cardColor,

                  primaryText,

                  secondaryText,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}