part of dart_signals;


class _SignalImpl {
  List _listeners;
  Object _sender;
  
  _SignalImpl(this._sender) : _listeners = new List();

  bool get _hasSubscribers => !_listeners.isEmpty;
  
  _SignalSubscriptionImpl listen(slot) {
    _SignalSubscriptionImpl subscription = _createSubscription(slot);
    _addListener(subscription);
    return subscription;
  }
  
  _SignalSubscriptionImpl _createSubscription(slot) {
    return new _SignalSubscriptionImpl(this, _sender, slot);
  }
  
  void _disconnect(_SignalListener listener) {
    assert(identical(listener._source, this));
    if (!_listeners.contains(listener)) {
      return;
    }
    _removeListener(listener);
  }
  
  void _emit(List<dynamic> positionalArguments, Map<dynamic, dynamic> namedArguments) {
    _forEachSubscriber((subscriber) {
      subscriber._emitData(positionalArguments, namedArguments);
    });
  }
  
  void _forEachSubscriber(
    void action(_SignalListener subscription)) {
    if (!_hasSubscribers) return;
    _listeners.forEach((_SignalListener current) {
      action(current);
    });
  }
  
  void _addListener(listener) {
    _listeners.add(listener);
  }
  
  void _removeListener(_SignalListener listener) {
    _listeners.remove(listener);
  }
}

abstract class SignalSubscription {
  void disconnect();
}

abstract class _SignalListener {
  final _SignalImpl _source;

  _SignalListener(this._source);
  
  _emitData(List<dynamic> positionalArguments, Map<dynamic, dynamic> namedArguments);
}

class _SignalSubscriptionImpl extends _SignalListener  
                              implements SignalSubscription {

  Object _sender;
  var _slot;
  
  _SignalSubscriptionImpl(_SignalImpl source, this._sender, this._slot) : super(source);
  
  void disconnect() {
    _source._disconnect(this);
  }
  
  void _emitData(List<dynamic> positionalArguments, Map<dynamic, dynamic> namedArguments) {
    if (_slot is SignalMapper) {
      return _slot.map(_sender);
    }
    Function.apply(_slot, positionalArguments, namedArguments);
  }
}
