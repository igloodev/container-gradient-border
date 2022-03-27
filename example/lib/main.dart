import 'package:flutter/material.dart';
import 'package:container_gradient_border/container_gradient_border.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ContainerGradientBorder(
            height: 200,
            width: 300,
            borderWidth: 7,
            colorList: const [Colors.blue, Colors.green, Colors.yellow],
            containerColor: Colors.red.shade400,
            borderRadius: 40,
            start: Alignment.topCenter,
            end: Alignment.bottomCenter,
            child: const Text("Test"),
            childAlignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
        ),
      ),
    );
  }
}
