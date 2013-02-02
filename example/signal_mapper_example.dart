library signal_mapper_example;

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
  SignalMapper<Option, String> mapper = new SignalMapper<Option, String>();
  
  textChangedSlot(String optionName) {
    Option option = mapper.mapping(optionName);
    print("${optionName} changed text to \"${option.text}\".");
  }

  Option o1 = new Option();
  Option o2 = new Option();
  
  mapper.setMapping(o1, "Option 1");
  mapper.setMapping(o2, "Option 2");
  
  o1.textChanged.connect(mapper);  
  o2.textChanged.connect(mapper);
  
  mapper.mapped.connect(textChangedSlot);

  o1.text = "New Text for Option 1";
  o2.text = "New Text for Option 2";
}

