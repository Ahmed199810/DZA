


class FirebaseConn {
  Map objectData = new Map();
  FirebaseConn(this.objectData);

  int getDataSize() {
    int size = objectData.keys.length;
    return size;
  }

  Object getValue(String key) {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      value = objectData[objectData.keys.elementAt(s)][key];
    }
    return value == null ? "" : value;
  }

  List<Map> getDataAsList() {
    List<Map> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val);
    }
    return value;
  }

}