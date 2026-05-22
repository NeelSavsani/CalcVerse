import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {

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
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: AspectRatio(

        aspectRatio: 1,

        child: Container(

          decoration: BoxDecoration(

            color: color,

            shape: BoxShape.circle,

            boxShadow: [

              BoxShadow(

                color: Colors.black.withOpacity(0.12),

                blurRadius: 8,

                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Center(

            child: Text(

              text,

              style: TextStyle(

                fontSize: 28,

                fontWeight: FontWeight.w500,

                color: color == const Color(0xFFF1F1F1)
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}