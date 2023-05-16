import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tetris_game/components/board.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 250, bottom: 100),
                child: SizedBox(
                  width: 250,
                  child: Image.asset(
                    "asset/The_Tetris_Company_logo.png",
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GameBoard(),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 70,
                        width: 70,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              blurRadius: 4.0,
                              spreadRadius: 1.0,
                              offset: const Offset(
                                0.0, // Move to right 7.0 horizontally
                                3.0, // Move to bottom 8.0 Vertically
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 75,
                        child: Icon(
                          Icons.forward,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
