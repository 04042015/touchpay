import 'package:flutter/foundation.dart';
import '../models/report.dart';
import '../services/api_service.dart';

class ReportProvider extends ChangeNotifier {
  SalesReport? _salesReport;
  InventoryReport? _inventoryReport;
  bool _isLoading = false;
  String? _errorMessage;

  SalesReport? get salesReport => _salesReport;
  InventoryReport? get inventoryReport => _inventoryReport;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load sales report
  Future<void> loadSalesReport(DateTime date) async {
    _setLoading(true);
    _clearError();

    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final response = await ApiService.get('reports/sales?date=$dateStr');
      _salesReport = SalesReport.fromJson(response['report']);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Load sales report for date range
  Future<void> loadSalesReportRange(DateTime startDate, DateTime endDate) async {
    _setLoading(true);
    _clearError();

    try {
      final startDateStr = startDate.toIso8601String().split('T')[0];
      final endDateStr = endDate.toIso8601String().split('T')[0];
      final response = await ApiService.get(
        'reports/sales?start_date=$startDateStr&end_date=$endDateStr',
      );
      _salesReport = SalesReport.fromJson(response['report']);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Load inventory report
  Future<void> loadInventoryReport() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.get('reports/inventory');
      _inventoryReport = InventoryReport.fromJson(response['report']);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Get daily sales summary
  Future<Map<String, dynamic>> getDailySalesSummary(DateTime date) async {
    _setLoading(true);
    _clearError();

    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final response = await ApiService.get('reports/sales/summary?date=$dateStr');
      _setLoading(false);
      return response['summary'];
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return {};
    }
  }

  // Get monthly sales summary
  Future<Map<String, dynamic>> getMonthlySalesSummary(int year, int month) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.get(
        'reports/sales/summary?year=$year&month=$month',
      );
      _setLoading(false);
      return response['summary'];
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return {};
    }
  }

  // Get top selling items
  Future<List<Map<String, dynamic>>> getTopSellingItems({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 10,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      String endpoint = 'reports/top-selling?limit=$limit';
      
      if (startDate != null) {
        endpoint += '&start_date=${startDate.toIso8601String().split('T')[0]}';
      }
      
      if (endDate != null) {
        endpoint += '&end_date=${endDate.toIso8601String().split('T')[0]}';
      }

      final response = await ApiService.get(endpoint);
      _setLoading(false);
      return List<Map<String, dynamic>>.from(response['items']);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return [];
    }
  }

  // Get low stock items
  Future<List<InventoryItem>> getLowStockItems() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.get('reports/inventory/low-stock');
      _setLoading(false);
      return (response['items'] as List)
          .map((item) => InventoryItem.fromJson(item))
          .toList();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return [];
    }
  }

  // Export sales report
  Future<String?> exportSalesReport(DateTime startDate, DateTime endDate) async {
    _setLoading(true);
    _clearError();

    try {
      final startDateStr = startDate.toIso8601String().split('T')[0];
      final endDateStr = endDate.toIso8601String().split('T')[0];
      final response = await ApiService.get(
        'reports/sales/export?start_date=$startDateStr&end_date=$endDateStr',
      );
      _setLoading(false);
      return response['download_url'];
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return null;
    }
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

  void clearReports() {
    _salesReport = null;
    _inventoryReport = null;
    notifyListeners();
  }
}
