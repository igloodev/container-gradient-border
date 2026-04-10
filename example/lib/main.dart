import 'package:flutter/material.dart';
import 'package:container_gradient_border/container_gradient_border.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContainerGradientBorder Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ContainerGradientBorder')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const _SectionLabel('LinearGradient — card'),
              const ContainerGradientBorder(
                borderWidth: 3,
                borderRadius: 16,
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                containerColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Text(
                  'Hello, Gradient Border!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 32),
              const _SectionLabel('RadialGradient — avatar placeholder'),
              ContainerGradientBorder(
                borderWidth: 4,
                borderRadius: 60,
                gradient: const RadialGradient(
                  colors: [Colors.orange, Colors.red],
                ),
                containerColor: Colors.grey.shade100,
                child: const SizedBox(
                  width: 100,
                  height: 100,
                  child: Icon(Icons.person, size: 56, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 32),
              const _SectionLabel('SweepGradient — pill button'),
              const ContainerGradientBorder(
                borderWidth: 2,
                borderRadius: 999,
                gradient: SweepGradient(
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.purple,
                    Colors.red,
                  ],
                ),
                containerColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                child: Text(
                  'Rainbow Button',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),
              const _SectionLabel('Multi-stop LinearGradient — input field style'),
              const ContainerGradientBorder(
                borderWidth: 1.5,
                borderRadius: 8,
                gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.teal, Colors.green],
                ),
                containerColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Search...', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const _SectionLabel('Transparent background'),
              const ContainerGradientBorder(
                borderWidth: 5,
                borderRadius: 12,
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.amber],
                ),
                child: SizedBox(width: 200, height: 80),
              ),
              const SizedBox(height: 32),
              const _SectionLabel('TextField — gradient border with focus state'),
              const _GradientTextField(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientTextField extends StatefulWidget {
  const _GradientTextField();

  @override
  State<_GradientTextField> createState() => _GradientTextFieldState();
}

class _GradientTextFieldState extends State<_GradientTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Focus(
        onFocusChange: (hasFocus) => setState(() => _focused = hasFocus),
        child: ContainerGradientBorder(
          borderWidth: 2,
          borderRadius: 10,
          gradient: LinearGradient(
            colors: _focused
                ? [Colors.deepPurple, Colors.pink]
                : [Colors.grey.shade300, Colors.grey.shade400],
          ),
          containerColor: Colors.white,
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Tap to focus...',
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: Colors.grey.shade600),
      ),
    );
  }
}
