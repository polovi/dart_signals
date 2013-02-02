library signals_example;

import 'package:dart_signals/dart_signals.dart';

class Option {
  Signal textChanged;
  Signal descriptionChanged;
  String _text;
  String _description;
  
  Option() {
    textChanged = new Signal(this);
    descriptionChanged = new Signal(this);
  }
  
  String get text => _text;
  
  set text(String text) {
    _text = text;
    textChanged.emit(_text);
  }
  
  String get description => _description;
  
  set description(String description) {
    _description = description;
    descriptionChanged.emit(_description);
  }
}


main() {

  Option o1 = new Option();
  Option o2 = new Option();
  Option o3 = new Option();
  Option o4 = new Option();
  
  SignalMapper<String> textChangedMapper = new SignalMapper<String>();
  
  textChangedMapper.setMapping(o1, "Option 1");
  textChangedMapper.setMapping(o2, "Option 2");
  textChangedMapper.setMapping(o3, "Option 3");
  
  void techChangedSlot({sender}) {
    Option o = textChangedMapper.mapping(sender) as Option;
    print("option ${sender} has new text: \"${o.text}\"");
  }

  print(textChangedMapper.mapping("Option 1")); // Instance of 'Option'
  
  o1.textChanged.connect(textChangedMapper);
  o2.textChanged.connect(textChangedMapper);
  o3.textChanged.connect(textChangedMapper);
  
  textChangedMapper.mapped.connect(techChangedSlot);
  
  o3.text = "Option 3 text";
  o1.text = "Option 1 text";
  o2.text = "Option 2 text";
  
  void descriptionChangedSlot(String description) {
    print("option Option 4 has new description: \"${description}\"");
  }
  
  o4.descriptionChanged.connect(descriptionChangedSlot);
  
  o4.description = "Option 4 description";
}

