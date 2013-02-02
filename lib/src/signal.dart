part of dart_signals;

class Signal {
  final _SignalImpl _signal;
  
  Signal([Object sender = null]) : _signal = new _SignalImpl(sender);
  
  connect(slot) => _signal.subscribe(slot);
  
  bool get hasSubscribers => _signal._hasSubscribers;
  
  noSuchMethod(InvocationMirror invocation) {
    if (invocation.isMethod && invocation.memberName == 'emit') {
      return _signal._emit(invocation.positionalArguments, invocation.namedArguments);
    }
    
    super.noSuchMethod(invocation);
  }
}