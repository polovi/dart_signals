library signal_disconnect_example;

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
  SignalSubscription connection;
  
  textChangedSlot(String text) {
    print("Text changed to \"${text}\" and slot disconnected.");
    connection.disconnect();
  }
  
  Option o = new Option();
  connection = o.textChanged.connect(textChangedSlot);
  o.text = "New Text";
  o.text = "New New Text";
}

