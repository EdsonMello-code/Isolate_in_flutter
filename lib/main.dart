import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final AppController controller;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    controller = AppController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (controller.state != AppState.loading) {
              await controller.performFibonnaccFormula();

              return animationController.repeat();
            }
          },
        ),
        body: AnimatedBuilder(
            animation: controller,
            builder: (context, __) {
              return Stack(
                children: [
                  ...controller.sequencia
                      .map((item) => Positioned(
                            top: double.parse(('${3 * item}')),
                            child: Container(
                              height: 20,

                              width: double.parse(('${item * 1.5}')),
                              // height: double.parse(('${item * 1.5}')),
                              color: Colors.amber,
                            ),
                          ))
                      .toList(),
                  ...controller.sequencia
                      .map((item) => Positioned(
                            right: 0,
                            top: double.parse(('${3 * item as int}')),
                            child: Container(
                              width: double.parse(('${item * 1.5}')),
                              height: 20,
                              color: Colors.amber,
                            ),
                          ))
                      .toList(),
                  Center(
                    child: AnimatedBuilder(
                        animation: animationController,
                        builder: (_, __) {
                          print(animationController.value);
                          return Transform.translate(
                            offset: Offset(0, -310 * animationController.value),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.red,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }));
  }
}

class AppController extends ChangeNotifier {
  AppState state = AppState.start;
  List sequencia = [];

  performFibonnaccFormula() async {
    try {
      state = AppState.loading;
      notifyListeners();
      final result = await createIsolate();
      sequencia = result;
      state = AppState.success;
      notifyListeners();
    } catch (e) {
      state = AppState.failure;
      notifyListeners();
    }
  }

  Future<List> createIsolate() async {
    final value = await compute(fibonacci, 50);
    return value;
  }

  static fibonacci(int value) {
    List lista = [];
    for (var i = 1; i < value; i++) {
      lista.add((i - 1 + i - 2).abs());
    }

    return lista;
  }
}

enum AppState { start, loading, success, failure }
