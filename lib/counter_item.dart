import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'global_state.dart';

class CounterItem extends StatelessWidget {
  final int index;
  final CounterModel counter;

  CounterItem({Key? key, required this.index, required this.counter}) : super(key: key);

  void showEditDialog(BuildContext context) {
    final globalState = context.read<GlobalState>();
    final TextEditingController labelController =
        TextEditingController(text: counter.label);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Counter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelController,
                decoration: const InputDecoration(labelText: 'Label'),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: Colors.primaries.map((color) {
                  return GestureDetector(
                    onTap: () {
                      globalState.updateCounter(index, color: color);
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(backgroundColor: color),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                globalState.updateCounter(index, label: labelController.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final globalState = context.read<GlobalState>();

    return ListTile(
      tileColor: counter.color,
      title: AnimatedCounter(value: counter.value),
      subtitle: Text(counter.label.isEmpty ? 'No Label' : counter.label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => globalState.incrementCounter(index),
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => globalState.decrementCounter(index),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => showEditDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => globalState.removeCounter(index),
          ),
        ],
      ),
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final int value;

  const AnimatedCounter({Key? key, required this.value}) : super(key: key);

  @override
  _AnimatedCounterState createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Text('Value: ${widget.value}', style: const TextStyle(fontSize: 16)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
