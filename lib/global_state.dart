import 'package:flutter/material.dart';

class CounterModel {
  int value;
  Color color;
  String label;

  CounterModel({this.value = 0, required this.color, this.label = ''});
}

class GlobalState extends ChangeNotifier {
  final List<CounterModel> counters = [];

  void addCounter() {
    counters.add(
      CounterModel(
        color: Colors.primaries[counters.length % Colors.primaries.length],
      ),
    );
    notifyListeners();
  }

  void removeCounter(int index) {
    counters.removeAt(index);
    notifyListeners();
  }

  void incrementCounter(int index) {
    counters[index].value++;
    notifyListeners();
  }

  void decrementCounter(int index) {
    if (counters[index].value > 0) counters[index].value--;
    notifyListeners();
  }

  void updateCounter(int index, {Color? color, String? label}) {
    if (color != null) counters[index].color = color;
    if (label != null) counters[index].label = label;
    notifyListeners();
  }

  void reorderCounters(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = counters.removeAt(oldIndex);
    counters.insert(newIndex, item);
    notifyListeners();
  }
}
