part of dart_signals;

class SignalMapper<K extends Object, V> {
  Map<K, V> senderMap;
  
  /** This signal is emitted when map() is signalled from an object that has a Type mapping set. */
  Signal mapped = new Signal();
  
  SignalMapper() {
    senderMap = new Map<K, V>();
  }
  
  /**
   * Adds a mapping so that when map() is signalled from the given sender, the signal mapped([id]) is emitted.
   * 
   * There may be at most one integer [id] for each sender.
   */
  void setMapping(K sender, V id) {
    if (senderMap.values.contains(id)) {
      throw new ExpectException('There may be at most one ID of specified Type for each sender.');
    }
    senderMap[sender] = id;
  }
  
  void removeMapping(K sender) {
    senderMap.remove(sender);
  }

  /**
   * Returns the sender object that is associated with the [id] of specified Type.
   */
  Object mapping(V id) {
    return senderMap.keys.where((k) => senderMap[k] == id).first;
  }
  
  /**
   * This slot emits signals based on which object sends signals to it.
   */
  void map(K sender) {
    if (senderMap.containsKey(sender)) {
      mapped.emit(sender:senderMap[sender]);
    }
  }
}