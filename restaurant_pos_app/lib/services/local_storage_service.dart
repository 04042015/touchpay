import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../config/app_config.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;
  static Database? _database;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _initDatabase();
  }

  // Initialize SQLite Database
  static Future<void> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, AppConfig.databaseName);

    _database = await openDatabase(
      path,
      version: AppConfig.databaseVersion,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  // Create database tables
  static Future<void> _createTables(Database db, int version) async {
    // Create tables for offline data storage
    await db.execute('''
      CREATE TABLE menu_items (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        image_url TEXT,
        is_available INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tables (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        capacity INTEGER NOT NULL,
        status TEXT NOT NULL,
        current_order_id TEXT,
        occupied_since TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        table_id TEXT NOT NULL,
        status TEXT NOT NULL,
        subtotal REAL NOT NULL,
        tax REAL NOT NULL,
        discount REAL NOT NULL,
        total REAL NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id TEXT PRIMARY KEY,
        order_id TEXT NOT NULL,
        menu_item_id TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        notes TEXT,
        FOREIGN KEY (order_id) REFERENCES orders (id),
        FOREIGN KEY (menu_item_id) REFERENCES menu_items (id)
      )
    ''');
  }

  // Handle database upgrades
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema changes
  }

  // SharedPreferences methods
  static Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<bool> setInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static Future<bool> setDouble(String key, double value) async {
    return await _prefs?.setDouble(key, value) ?? false;
  }

  static double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  static Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  static Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }

  // Database methods
  static Database? get database => _database;

  static Future<List<Map<String, dynamic>>> query(
    String table, {
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    return await _database?.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    ) ?? [];
  }

  static Future<int> insert(String table, Map<String, dynamic> values) async {
    return await _database?.insert(table, values) ?? 0;
  }

  static Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    return await _database?.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    ) ?? 0;
  }

  static Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    return await _database?.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    ) ?? 0;
  }
}
