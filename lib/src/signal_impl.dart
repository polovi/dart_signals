part of dart_signals;


class _SignalImpl {
  List _subscribers;
  Object _sender;
  
  _SignalImpl(this._sender) : _subscribers = new List();

  bool get _hasSubscribers => !_subscribers.isEmpty;
  
  _SignalSubscriptionImpl subscribe(slot) {
    _SignalSubscriptionImpl subscription = _createSubscription(slot);
    _addSubscriber(subscription);
    return subscription;
  }
  
  _SignalSubscriptionImpl _createSubscription(slot) {
    return new _SignalSubscriptionImpl(this, _sender, slot);
  }
  
  void _disconnect(_SignalSubscriber subscriber) {
    assert(identical(subscriber._source, this));
    if (!_subscribers.contains(subscriber)) {
      return;
    }
    _removeSubscriber(subscriber);
  }
  
  void _emit(List<dynamic> positionalArguments, Map<dynamic, dynamic> namedArguments) {
    _forEachSubscriber((subscriber) {
      subscriber._emitData(positionalArguments, namedArguments);
    });
  }
  
  void _forEachSubscriber(
    void action(_SignalSubscriber subscription)) {
    if (!_hasSubscribers) return;
    _subscribers.forEach((_SignalSubscriber current) {
      action(current);
    });
  }
  
  void _addSubscriber(subscriber) {
    _subscribers.add(subscriber);
  }
  
  void _removeSubscriber(_SignalSubscriber subscriber) {
    _subscribers.remove(subscriber);
  }
}

abstract class SignalSubscription {
  void disconnect();
}

abstract class _SignalSubscriber {
  final _SignalImpl _source;

  _SignalSubscriber(this._source);
  
  _emitData(List<dynamic> positionalArguments, Map<dynamic, dynamic> namedArguments);
}

class _SignalSubscriptionImpl extends _SignalSubscriber  
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
