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

  SignalMapper<Option, String> textChangedMapper = new SignalMapper<Option, String>();
  SignalMapper<Option, Option> textChangedObjectMapper = new SignalMapper<Option, Option>();
  
  textChangedMapper.setMapping(o1, "Option 1");
  textChangedMapper.setMapping(o2, "Option 2");
  textChangedMapper.setMapping(o3, "Option 3");
  
  textChangedObjectMapper.setMapping(o1, o1);
  textChangedObjectMapper.setMapping(o2, o2);
  textChangedObjectMapper.setMapping(o3, o3);
  
  void techChangedSlot({sender}) {
    Option o = textChangedMapper.mapping(sender) as Option;
    print("String mapping: option ${sender} has new text: \"${o.text}\"");
  }
  void techChangedSlotObject({sender}) {
    print("Object mapping: option has new text: \"${sender.text}\"");
  }

  print(textChangedMapper.mapping("Option 1")); // Instance of 'Option'

  o1.textChanged.connect(textChangedMapper);
  o2.textChanged.connect(textChangedMapper);
  o3.textChanged.connect(textChangedMapper);
  
  o1.textChanged.connect(textChangedObjectMapper);
  o2.textChanged.connect(textChangedObjectMapper);
  o3.textChanged.connect(textChangedObjectMapper);
  
  textChangedMapper.mapped.connect(techChangedSlot);
  textChangedObjectMapper.mapped.connect(techChangedSlotObject);
  
  o3.text = "Option 3 text";
  o1.text = "Option 1 text";
  o2.text = "Option 2 text";
  
  void descriptionChangedSlot(String description) {
    print("option Option 4 has new description: \"${description}\"");
  }
  
  o4.descriptionChanged.connect(descriptionChangedSlot);
  
  o4.description = "Option 4 description";
}

