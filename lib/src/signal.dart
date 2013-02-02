part of dart_signals;

class Signal {
  final _SignalImpl _signal;
  
  Signal([Object sender = null]) : _signal = new _SignalImpl(sender);
  
  connect(slot) => _signal.listen(slot);
  
  bool get hasSubscribers => _signal._hasSubscribers;
  
  noSuchMethod(InvocationMirror invocation) {
    if (!invocation.isMethod || invocation.memberName != 'emit') {
      invocation.namedArguments['x'] = "ahoj";
      super.noSuchMethod(invocation);
    }

    _signal._emit(invocation.positionalArguments, 
                  invocation.namedArguments);
  }
}