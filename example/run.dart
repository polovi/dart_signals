library signals_example;

import 'package:dart_signals/dart_signals.dart';

class Button {
  Signal textChanged;
  String text;
  
  Button() {
    textChanged = new Signal(this);
  }
  
  void setText(String text) {
    this.text = text;
    textChanged.emit(text);
  }
}


main() {

  Button b1 = new Button();
  Button b2 = new Button();
  Button b3 = new Button();
  
  SignalMapper<int> textChangedMapper = new SignalMapper<int>();
  
  textChangedMapper.setMapping(b1, 1);
  textChangedMapper.setMapping(b2, 2);
  textChangedMapper.setMapping(b3, 3);
  
  void slot({sender}) {
    Button b = textChangedMapper.mapping(sender) as Button;
    print("button ${sender} has new text: ${b.text}");
  }

  b1.textChanged.connect(textChangedMapper);
  b2.textChanged.connect(textChangedMapper);
  b3.textChanged.connect(textChangedMapper);
  
  textChangedMapper.mapped.connect(slot);
  
  b3.setText("Button 3");
  b1.setText("Button 1");
  b2.setText("Button 2");
}

