library dart_signals_test;

import 'dart:async';
import 'package:unittest/unittest.dart';
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
  group('Signals', () {
    test('connect', () {
      Option o = new Option();
      
      expect(
          o.textChanged.hasSubscribers,
          equals(false)
      );
      
      o.textChanged.connect(() => null);
      
      expect(
           o.textChanged.hasSubscribers,
          equals(true)
      );
    });
    
    test('disconnect', () {
      Option o = new Option();
      SignalSubscription connection = o.textChanged.connect(() => null);
      
      expect(connection, isNotNull);
      expect(
          o.textChanged.hasSubscribers,
          equals(true)
      );
      
      connection.disconnect();
      
      expect(
          o.textChanged.hasSubscribers,
          equals(false)
      );
    });
    
    test('emit', () {
      Option o = new Option();
      o.textChanged.connect((String text) => expect(text, "new text"));
      o.textChanged.emit("new text");
    });
    
    test('mapping', () {
      Option o = new Option();
      SignalMapper<Option, int> mapper = new SignalMapper<Option, int>();
      
      expect(
          mapper.mapping(1),
          equals(null)
      );
      
      mapper.setMapping(o, 1);
      
      expect(
          mapper.mapping(1),
          equals(o)
      );
    });
    
    test('mapper emit', () {
      Option o1 = new Option();
      Option o2 = new Option();
      SignalMapper<Option, int> mapper = new SignalMapper<Option, int>();
      mapper.setMapping(o1, 1);
      mapper.setMapping(o2, 2);

      o1.textChanged.connect(mapper);
      o2.textChanged.connect(mapper);
      mapper.mapped.connect((int id) => expect(id, 1));
      o1.textChanged.emit("new text");
    });
    
  });
}

