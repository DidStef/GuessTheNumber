import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const GuessTheNumber());
}

class GuessTheNumber extends StatelessWidget {
  const GuessTheNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final _controller;
  late String _result;
  late final _random;
  late int _number;

  @override
  void initState() {
    _controller = TextEditingController();
    _result = "";
    _random = Random();
    _number = generate(0, 100);
    // Do some other stuff
    super.initState();
  }

  int generate(int min, int max) => (min + _random.nextInt(max - min)).toInt();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Guess my number"),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Container(
                child: const Text(
                  "I'm thinking of a number between 1 and 100.",
                  style: TextStyle(fontSize: 16),
                ),
                padding: const EdgeInsets.all(16),
              ),
              Container(
                child: const Text(
                  "It's your turn to guess my number!",
                  style: TextStyle(fontSize: 16),
                ),
                padding: const EdgeInsets.all(8),
              ),
              Container(
                child: Text(
                  _result,
                  style: const TextStyle(fontSize: 32, color: Colors.grey),
                ),
                padding: EdgeInsets.all(16),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: const Text(
                        "Try a number!",
                        style: TextStyle(color: Colors.grey, fontSize: 32),
                      ),
                      padding: EdgeInsets.only(top: 16),
                    ),
                    Container(
                      child: TextFormField(
                        controller: _controller,
                        keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                        validator: (String? value) {
                          _result = value!;
                          if (value == null || value.isEmpty) {
                            return "Please enter a number";
                          }
                          try {
                            final int? res = int.parse(value);
                            if (res == null) {
                              return "Please enter a number";
                            }
                          } on Exception catch (_){
                            return "Please enter a number";
                          }
                          return null;
                        },
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                    Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () {
                            final bool? valid = Form.of(context)?.validate();
                            if (valid != null && valid) {
                              int res = int.parse(_controller.text);
                              if (res == _number) {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("You guessed right"),
                                      content: Text("It was $_number"),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            _controller.clear();
                                            _number = generate(0, 100);
                                            setState(() {
                                              _result = "";
                                            });
                                            Navigator.of(ctx).pop();
                                          },
                                          child: const Text("Try again"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    ),
                                );
                              } else if (res < _number) {
                                setState(() {
                                  _result = "You tried ${res} \n Try higher";
                                });
                              } else if (res > _number) {
                                setState(() {
                                  _result = "You tried ${res} \n Try lower";
                                });
                              }
                            }
                          },
                          child: Text("Guess"),
                        );
                      }
                    )
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
