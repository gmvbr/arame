import 'dart:convert';
import 'dart:io';

class Config {
  final Map<String, dynamic> _data;
  const Config(this._data);

  void _internalSetValue(String key, dynamic value) => _data[key] = value;

  void remove(String key) {
    _data.remove(key);
  }

  void clear() {
    _data.clear();
  }

  void setString(String key, String value) {
    _internalSetValue(key, value);
  }

  void setBool(String key, bool value) {
    _internalSetValue(key, value);
  }

  void setInt(String key, int value) {
    _internalSetValue(key, value);
  }

  void setDouble(String key, double value) {
    _internalSetValue(key, value);
  }

  void setStringList(String key, List<String> value) {
    _internalSetValue(key, value);
  }

  String? getString(String key) {
    return _data[key] as String?;
  }

  bool? getBool(String key) {
    return _data[key] as bool?;
  }

  int? getInt(String key) {
    return _data[key] as int?;
  }

  double? getDouble(String key) {
    return _data[key] as double?;
  }

  bool containsKey(String key) {
    return _data.containsKey(key);
  }

  List<String>? getStringList(String key) {
    var list = _data[key] as List<dynamic>?;
    if (list != null && list is! List<String>) {
      _data[key] = list.cast<String>().toList();
    }
    return _data[key]?.toList() as List<String>?;
  }
}

class ConfigFile extends Config {
  final File file;
  const ConfigFile._(this.file, super.data);

  static Future<ConfigFile> loads(File file) async {
    return ConfigFile._(file, await _load(file));
  }

  Future<void> save(Map<String, dynamic> data) async {
    await file.writeAsString(jsonEncode(data));
  }

  @override
  void _internalSetValue(String key, value) {
    super._internalSetValue(key, value);
    save(_data);
  }

  @override
  void remove(String key) {
    super.remove(key);
    save(_data);
  }

  @override
  void clear() {
    super.clear();
    save(_data);
  }

  static Future<Map<String, dynamic>> _load(File file) async {
    if (file.existsSync()) {
      var content = await file.readAsString();
      var data = jsonDecode(content);
      if (data is Map<String, dynamic>) {
        return data;
      }
    }
    return {};
  }
}
