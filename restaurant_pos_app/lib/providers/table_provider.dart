import 'package:flutter/foundation.dart';
import '../models/table.dart';
import '../services/api_service.dart';

class TableProvider extends ChangeNotifier {
  List<Table> _tables = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Table> get tables => _tables;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get available tables
  List<Table> get availableTables =>
      _tables.where((table) => table.status == TableStatus.available).toList();

  // Get occupied tables
  List<Table> get occupiedTables =>
      _tables.where((table) => table.status == TableStatus.occupied).toList();

  // Load all tables
  Future<void> loadTables() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.get('tables');
      _tables = (response['tables'] as List)
          .map((table) => Table.fromJson(table))
          .toList();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Add new table
  Future<bool> addTable(String name, int capacity) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.post('tables', {
        'name': name,
        'capacity': capacity,
        'status': TableStatus.available.name,
      });

      final newTable = Table.fromJson(response['table']);
      _tables.add(newTable);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Update table
  Future<bool> updateTable(Table table) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.put('tables/${table.id}', table.toJson());
      final updatedTable = Table.fromJson(response['table']);

      final index = _tables.indexWhere((t) => t.id == table.id);
      if (index >= 0) {
        _tables[index] = updatedTable;
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Update table status
  Future<bool> updateTableStatus(String tableId, TableStatus status) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.put('tables/$tableId/status', {
        'status': status.name,
      });

      final updatedTable = Table.fromJson(response['table']);
      final index = _tables.indexWhere((t) => t.id == tableId);
      if (index >= 0) {
        _tables[index] = updatedTable;
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Delete table
  Future<bool> deleteTable(String tableId) async {
    _setLoading(true);
    _clearError();

    try {
      await ApiService.delete('tables/$tableId');
      _tables.removeWhere((table) => table.id == tableId);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Get table by ID
  Table? getTableById(String tableId) {
    try {
      return _tables.firstWhere((table) => table.id == tableId);
    } catch (e) {
      return null;
    }
  }

  // Occupy table
  Future<bool> occupyTable(String tableId, String orderId) async {
    return await updateTableStatus(tableId, TableStatus.occupied);
  }

  // Free table
  Future<bool> freeTable(String tableId) async {
    return await updateTableStatus(tableId, TableStatus.available);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
