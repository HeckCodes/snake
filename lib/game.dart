import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static List<int> snakePosition = [363, 378, 393, 408];
  static List<int> poisonPosition = [];
  int score = 0;
  int snakeFoodPosition = Random().nextInt(449);
  static int numberOfSquares = 450;
  bool gameRunning = false;
  static const nextFrameDuration = Duration(milliseconds: 300);
  String movementDirection = 'up';

  stop() {
    setState(() {
      gameRunning = false;
    });
  }

  void start() {
    score = 0;
    setState(() {
      gameRunning = true;
      snakePosition = [363, 378, 393, 408];
    });
    generatePoisonPosition();
    Timer.periodic(nextFrameDuration, (timer) {
      if (!gameRunning) {
        timer.cancel();
      }
      moveSnake();
    });
  }

  void moveSnake() {
    if (snakePosition.length == 0) {
      stop();
    }
    setState(() {
      switch (movementDirection) {
        case 'up':
          if (snakePosition.first < 0) {
            stop();
          }
          if (snakePosition.first == snakeFoodPosition) {
            generateNewFoodPosition();
          }
          if (poisonPosition.contains(snakePosition.first)) {
            snakePosition.remove(snakePosition.last);
            snakePosition.remove(snakePosition.last);
            generatePoisonPosition();
          }
          int prev = 0;
          int temp = 0;
          int prevIndex = -1;
          for (int i = 0; i < snakePosition.length; i++) {
            if (prevIndex == -1) {
              prev = snakePosition[i];
              snakePosition[i] -= 15;
              prevIndex = i;
            } else if (i == prevIndex + 1) {
              temp = snakePosition[i];
              snakePosition[i] = prev;
              prev = temp;
              prevIndex = i;
            }
          }
          break;

        case 'right':
          if (snakePosition.first == snakeFoodPosition) {
            generateNewFoodPosition();
          }
          if (poisonPosition.contains(snakePosition.first)) {
            snakePosition.remove(snakePosition.last);
            snakePosition.remove(snakePosition.last);
            generatePoisonPosition();
          }
          int prev = 0;
          int temp = 0;
          int prevIndex = -1;
          for (int i = 0; i < snakePosition.length; i++) {
            if (prevIndex == -1) {
              prev = snakePosition[i];
              snakePosition[i] += 1;
              prevIndex = i;
            } else if (i == prevIndex + 1) {
              temp = snakePosition[i];
              snakePosition[i] = prev;
              prev = temp;
              prevIndex = i;
            }
          }
          break;

        case 'left':
          if (snakePosition.first == snakeFoodPosition) {
            generateNewFoodPosition();
          }
          if (poisonPosition.contains(snakePosition.first)) {
            snakePosition.remove(snakePosition.last);
            snakePosition.remove(snakePosition.last);
            generatePoisonPosition();
          }
          int prev = 0;
          int temp = 0;
          int prevIndex = -1;
          for (int i = 0; i < snakePosition.length; i++) {
            if (prevIndex == -1) {
              prev = snakePosition[i];
              snakePosition[i] -= 1;
              prevIndex = i;
            } else if (i == prevIndex + 1) {
              temp = snakePosition[i];
              snakePosition[i] = prev;
              prev = temp;
              prevIndex = i;
            }
          }
          break;

        case 'down':
          if (snakePosition.first == snakeFoodPosition) {
            generateNewFoodPosition();
          }
          if (snakePosition.first > 449) {
            stop();
          }
          if (poisonPosition.contains(snakePosition.first)) {
            snakePosition.remove(snakePosition.last);
            snakePosition.remove(snakePosition.last);
            generatePoisonPosition();
          }
          int prev = 0;
          int temp = 0;
          int prevIndex = -1;
          for (int i = 0; i < snakePosition.length; i++) {
            if (prevIndex == -1) {
              prev = snakePosition[i];
              snakePosition[i] += 15;
              prevIndex = i;
            } else if (i == prevIndex + 1) {
              temp = snakePosition[i];
              snakePosition[i] = prev;
              prev = temp;
              prevIndex = i;
            }
          }
          break;
      }
    });
  }

  void generateNewFoodPosition() {
    snakePosition.add(snakePosition.last - 1);
    setState(() {
      score += 1;
      snakeFoodPosition = Random().nextInt(449);
    });
  }

  void generatePoisonPosition() {
    setState(() {
      poisonPosition.add(Random().nextInt(449));
      poisonPosition.add(Random().nextInt(449));
      poisonPosition.add(Random().nextInt(449));
      poisonPosition.add(Random().nextInt(449));
      poisonPosition.add(Random().nextInt(449));
      poisonPosition.add(Random().nextInt(449));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 16),
                child: Text(
                  "SCORE: " + score.toString(),
                  style: GoogleFonts.pressStart2p(
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25, top: 16),
                child: (gameRunning)
                    ? TextButton(
                        onPressed: () {
                          stop();
                        },
                        child: Container(
                          child: Text(
                            "RESET",
                            style: GoogleFonts.pressStart2p(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          start();
                        },
                        child: Container(
                          child: Text(
                            "START",
                            style: GoogleFonts.pressStart2p(
                              color: Colors.blueAccent,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (movementDirection != 'up' && details.delta.dy > 0) {
                movementDirection = 'down';
                print(movementDirection);
              } else if (movementDirection != 'down' && details.delta.dy < 0) {
                movementDirection = 'up';
                print(movementDirection);
              }
            },
            onHorizontalDragUpdate: (details) {
              if (movementDirection != 'left' && details.delta.dx > 0) {
                movementDirection = 'right';
                print(movementDirection);
              } else if (movementDirection != 'right' && details.delta.dx < 0) {
                movementDirection = 'left';
                print(movementDirection);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 15),
                itemBuilder: (context, index) {
                  if (snakePosition.contains(index)) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else if (index == snakeFoodPosition) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.green,
                          ),
                        ),
                      ),
                    );
                  } else if (poisonPosition.contains(index)) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
