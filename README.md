#dart_signals

[Dartlang](http://www.dartlang.org/) test implementation of QT(pyQT) signal/slot mechanism. 
Basic functions such as connecting, disconnecting, SignalMapper are implemented and work.
There's many limitations like catching and store real signal sender, or usage of noSuchMethod and no arguments type control until arguments are passed to slot function.

[![Build Status](https://drone.io/github.com/polovi/dart_signals/status.png)](https://drone.io/github.com/polovi/dart_signals/latest)

##Getting Started

Add the <strong>dart_signals</strong> package to your pubspec.yaml file
```dart
dependencies:
  dart_signals:
    git: https://github.com/polovi/dart_signals.git
```
and run <code>pub install</code> to install <strong>dart_signals</strong> (including its dependencies). Now add import
```dart
import 'package:dart_signals/dart_signals.dart';
```
Create simple signal and connect custom slot method. Then emit signal with method <code>.emit()</code>
```dart
Signal customSignal = new Signal();
customSignal.connect(() => print("slot emitted"));
customSignal.emit();
```
Signal is emitted with optional list of arguments
```dart
Signal customSignal = new Signal();
customSignal.connect((String newText, String oldText) => print("slot emitted"));
customSignal.emit("new text", "old text");
```

###SignalMapper
if it is necessary to connect multiple signals to a single slot and know who sent the signal, it is possible to use <strong>SignalMapper</strong>.
The sender must be set now as Signal contructor parametr.
```dart
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

SignalMapper<Option, String> mapper = new SignalMapper<Option, String>();

Option o = new Option();
mapper.setMapping(o, "Option name");

o.textChanged.connect(mapper);  

mapper.mapped.connect((String optionName) => print("signal emitter: ${optionName}");

o.text = "new text";
```

More [examples](https://github.com/polovi/dart_signals/tree/master/example)

Running Tests
-------------
All tests should be passing.
```shell
# Make sure dependencies are installed
pub install

# Run Dart unittests
dart test/run.dart
```
