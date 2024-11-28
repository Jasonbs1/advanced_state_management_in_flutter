import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'global_state.dart';
import 'counter_item.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GlobalState(),
      child: CounterApp(),
    ),
  );
}

class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Advanced Counter App')),
        body: CounterList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<GlobalState>().addCounter(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class CounterList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalState = context.watch<GlobalState>();
    final counters = globalState.counters;

    return ReorderableListView.builder(
      itemCount: counters.length,
      itemBuilder: (context, index) {
        final counter = counters[index];
        return CounterItem(
          key: ValueKey(index),
          index: index,
          counter: counter,
        );
      },
      onReorder: globalState.reorderCounters,
    );
  }
}
