import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {

  final List<String> history;

  final VoidCallback onClearHistory;

  const HistoryScreen({
    super.key,
    required this.history,
    required this.onClearHistory,
  });

  @override
  State<HistoryScreen> createState() =>
      _HistoryScreenState();
}

class _HistoryScreenState
    extends State<HistoryScreen> {

  void showClearDialog(bool isDark) {

    showDialog(

      context: context,

      builder: (dialogContext) {

        return AlertDialog(

          backgroundColor:
          isDark
              ? const Color(0xFF1A2238)
              : Colors.white,

          shape: RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(24),
          ),

          title: Text(

            "Clear All History?",

            style: TextStyle(

              color:
              isDark
                  ? Colors.white
                  : Colors.black,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          content: Text(

            "This action cannot be undone.",

            style: TextStyle(

              color:
              isDark
                  ? Colors.grey.shade300
                  : Colors.grey.shade700,
            ),
          ),

          actions: [

            // CANCEL BUTTON
            TextButton(

              onPressed: () {

                Navigator.pop(
                  dialogContext,
                );
              },

              child: Text(

                "Cancel",

                style: TextStyle(

                  color:
                  isDark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),

            // CLEAR BUTTON
            ElevatedButton(

              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                Colors.red,

                shape:
                RoundedRectangleBorder(

                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),
              ),

              onPressed: () {

                widget.onClearHistory();

                setState(() {});

                Navigator.pop(
                  dialogContext,
                );
              },

              child: const Text(

                "Clear",

                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      backgroundColor:
      isDark
          ? const Color(0xFF0D1326)
          : Colors.white,

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
        isDark
            ? const Color(0xFF0D1326)
            : Colors.white,

        iconTheme: IconThemeData(

          color:
          isDark
              ? Colors.white
              : Colors.black,
        ),

        title: Text(

          "History",

          style: TextStyle(

            color:
            isDark
                ? Colors.white
                : Colors.black,

            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          // CLEAR HISTORY BUTTON
          if (widget.history.isNotEmpty)

            IconButton(

              icon: Icon(

                Icons.delete_outline,

                color:
                isDark
                    ? Colors.redAccent
                    : Colors.red,
              ),

              onPressed: () {

                showClearDialog(
                  isDark,
                );
              },
            ),
        ],
      ),

      body: AnimatedSwitcher(

        duration:
        const Duration(
          milliseconds: 250,
        ),

        child: widget.history.isEmpty

            ? Center(

          key:
          const ValueKey(
            "empty",
          ),

          child: Column(

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              Icon(

                Icons.history,

                size: 80,

                color:
                isDark
                    ? Colors.grey.shade600
                    : Colors.grey.shade400,
              ),

              const SizedBox(height: 20),

              Text(

                "No History Yet",

                style: TextStyle(

                  fontSize: 24,

                  fontWeight:
                  FontWeight.w600,

                  color:
                  isDark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        )

            : ListView.builder(

          key:
          const ValueKey(
            "history",
          ),

          padding:
          const EdgeInsets.all(16),

          itemCount:
          widget.history.length,

          itemBuilder:
              (context, index) {

            // Reverse order
            // (latest first)
            String item =
            widget.history[
            widget.history.length -
                1 -
                index
            ];

            return AnimatedContainer(

              duration:
              const Duration(
                milliseconds: 200,
              ),

              margin:
              const EdgeInsets.only(
                bottom: 14,
              ),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),

              decoration: BoxDecoration(

                color:
                isDark
                    ? const Color(
                    0xFF1A2238)
                    : const Color(
                    0xFFF4F4F4),

                borderRadius:
                BorderRadius.circular(
                  22,
                ),

                boxShadow: [

                  BoxShadow(

                    color:
                    Colors.black
                        .withOpacity(
                      0.06,
                    ),

                    blurRadius: 8,

                    offset:
                    const Offset(
                      0,
                      4,
                    ),
                  ),
                ],
              ),

              child: Row(

                children: [

                  Icon(

                    Icons.history,

                    color:
                    isDark
                        ? Colors.orange
                        : Colors.deepOrange,
                  ),

                  const SizedBox(
                    width: 14,
                  ),

                  Expanded(

                    child: Text(

                      item,

                      style: TextStyle(

                        fontSize: 22,

                        fontWeight:
                        FontWeight.w500,

                        color:
                        isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}