import 'package:flutter/material.dart';

class CalcButton extends StatefulWidget {

  final String text;
  final VoidCallback onTap;
  final Color color;

  const CalcButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
  });

  @override
  State<CalcButton> createState() =>
      _CalcButtonState();
}

class _CalcButtonState
    extends State<CalcButton> {

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {

    bool isLightButton =
        widget.color ==
            const Color(0xFFF1F1F1);

    // Press animation color
    Color pressedColor =
    isLightButton
        ? Colors.grey.shade300
        : widget.color.withOpacity(0.75);

    return GestureDetector(

      onTapDown: (_) {

        setState(() {

          isPressed = true;
        });
      },

      onTapUp: (_) {

        setState(() {

          isPressed = false;
        });

        widget.onTap();
      },

      onTapCancel: () {

        setState(() {

          isPressed = false;
        });
      },

      child: AspectRatio(

        aspectRatio: 1,

        child: AnimatedContainer(

          duration:
          const Duration(
            milliseconds: 80,
          ),

          curve: Curves.easeOut,

          transformAlignment:
          Alignment.center,

          transform: Matrix4.identity()
            ..scale(
              isPressed ? 0.88 : 1.0,
            ),

          decoration: BoxDecoration(

            // CHANGE COLOR ON PRESS
            color:
            isPressed
                ? pressedColor
                : widget.color,

            shape: BoxShape.circle,

            boxShadow: [

              BoxShadow(

                color:
                Colors.black.withOpacity(
                  isPressed ? 0.05 : 0.12,
                ),

                blurRadius:
                isPressed ? 3 : 8,

                offset: Offset(
                  0,
                  isPressed ? 2 : 4,
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
              isPressed ? 0.92 : 1.0,

              child: Text(

                widget.text,

                style: TextStyle(

                  fontSize: 28,

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
    );
  }
}