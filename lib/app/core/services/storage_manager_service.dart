import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Enum for all storage keys - Type safe and prevents typos
enum StorageKey {
  bearerToken,
  languageCode,

  themeMode,
  isRememberIdPass,
  currentUser,
  isFirstTimeUser,
}

/// Local Storage Manager Service
/// Provides a centralized, type-safe interface for all local storage operations
class StorageManagerService extends GetxService {
  static StorageManagerService get to => Get.find();

  late final GetStorage _box;

  /// Initialize storage
  Future<StorageManagerService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    Get.log('✅ Storage Manager Service initialized');
    return this;
  }

  /// Write data to storage
  /// Returns true if successful, false otherwise
  Future<bool> write<T>(StorageKey key, T value) async {
    try {
      await _box.write(_getKey(key), value);
      Get.log('💾 Storage Write: ${_getKey(key)} = $value');
      return true;
    } catch (e) {
      Get.log('❌ Storage Write Error: ${_getKey(key)} - $e');
      return false;
    }
  }

  /// Read data from storage
  /// Returns the value if found, otherwise returns null or provided defaultValue
  T? read<T>(StorageKey key, {T? defaultValue}) {
    try {
      final value = _box.read<T>(_getKey(key));
      if (value != null) {
        Get.log('📖 Storage Read: ${_getKey(key)} = $value');
        return value;
      }
      return defaultValue;
    } catch (e) {
      Get.log('❌ Storage Read Error: ${_getKey(key)} - $e');
      return defaultValue;
    }
  }

  /// Delete data from storage
  /// Returns true if successful, false otherwise
  Future<bool> delete(StorageKey key) async {
    try {
      await _box.remove(_getKey(key));
      Get.log('🗑️ Storage Delete: ${_getKey(key)}');
      return true;
    } catch (e) {
      Get.log('❌ Storage Delete Error: ${_getKey(key)} - $e');
      return false;
    }
  }

  /// Check if key exists in storage
  bool has(StorageKey key) {
    return _box.hasData(_getKey(key));
  }

  /// Clear all data from storage
  Future<bool> clearAll() async {
    try {
      await _box.erase();
      Get.log('🧹 Storage Cleared: All data removed');
      return true;
    } catch (e) {
      Get.log('❌ Storage Clear Error: $e');
      return false;
    }
  }

  /// Get all keys currently stored
  Iterable<String> getKeys() {
    return _box.getKeys();
  }

  /// Get storage values
  Map<String, dynamic> getValues() {
    try {
      final keys = _box.getKeys().cast<String>();
      final Map<String, dynamic> values = {};

      for (var key in keys) {
        values[key] = _box.read(key);
      }

      Get.log('📊 Storage GetValues: Found ${values.length} entries');
      return values;
    } catch (e) {
      Get.log('❌ Storage GetValues Error: $e');
      return {};
    }
  }

  /// Convert enum to string key
  String _getKey(StorageKey key) {
    return key.name;
  }

  /// Listen to changes on a specific key
  /// Returns a listener that you need to dispose
  void listen(StorageKey key, Function(dynamic) callback) {
    _box.listenKey(_getKey(key), callback);
  }

  /// Write if absent - only writes if key doesn't exist
  Future<bool> writeIfAbsent<T>(StorageKey key, T value) async {
    if (!has(key)) {
      return await write(key, value);
    }
    return false;
  }

  /// Write multiple values at once
  Future<bool> writeMany(Map<StorageKey, dynamic> data) async {
    try {
      for (var entry in data.entries) {
        await _box.write(_getKey(entry.key), entry.value);
      }
      Get.log('💾 Storage Write Many: ${data.length} items');
      return true;
    } catch (e) {
      Get.log('❌ Storage Write Many Error: $e');
      return false;
    }
  }

  /// Delete multiple values at once
  Future<bool> deleteMany(List<StorageKey> keys) async {
    try {
      for (var key in keys) {
        await _box.remove(_getKey(key));
      }
      Get.log('🗑️ Storage Delete Many: ${keys.length} items');
      return true;
    } catch (e) {
      Get.log('❌ Storage Delete Many Error: $e');
      return false;
    }
  }
}
