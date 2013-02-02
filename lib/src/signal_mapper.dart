part of dart_signals;

class SignalMapper<T> {
  Map<Object, T> hashMap;
  
  /** This signal is emitted when map() is signalled from an object that has a Type mapping set. */
  Signal mapped = new Signal();
  
  SignalMapper() {
    hashMap = new Map<Object, T>();
  }
  
  /**
   * Adds a mapping so that when map() is signalled from the given sender, the signal mapped([id]) is emitted.
   * 
   * There may be at most one integer [id] for each sender.
   */
  void setMapping(Object sender, T id) {
    if (hashMap.values.contains(id)) {
      throw new ExpectException('There may be at most one ID of specified Type for each sender.');
    }
    hashMap[sender] = id;
  }
  
  void removeMapping(Object sender) {
    hashMap.remove(sender);
  }

  /**
   * Returns the sender object that is associated with the [id] of specified Type.
   */
  Object mapping(T id) {
    return hashMap.keys.where((k) => hashMap[k] == id).first;
  }
  
  /**
   * This slot emits signals based on which object sends signals to it.
   */
  T map(Object sender) {
    if (hashMap.containsKey(sender)) {
      mapped.emit(sender:hashMap[sender]);
    }
  }
}