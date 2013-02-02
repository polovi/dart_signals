library simple_signal_example;

import 'package:dart_signals/dart_signals.dart';

class Option {
  Signal textChanged;
  String _text;
  
  Option() {
    textChanged = new Signal(this);
  }
  
  String get text => _text;
  
  set text(String text) {
    _text = text;
    textChanged.emit(_text);
  }
}

main() {
  textChangedSlot(String text) {
    print("Text changed to \"${text}\".");
  }
  
  Option o = new Option();
  o.textChanged.connect(textChangedSlot);
  o.text = "New Text";
}

