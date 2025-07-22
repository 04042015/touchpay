import 'menu_item.dart';
class SalesReport {
  final DateTime date;
  final double totalSales;
  final int totalOrders;
  final double averageOrderValue;
  final Map<String, double> salesByCategory;
  final List<MenuItem> topSellingItems;

  SalesReport({
    required this.date,
    required this.totalSales,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.salesByCategory,
    required this.topSellingItems,
  });

  factory SalesReport.fromJson(Map<String, dynamic> json) {
    return SalesReport(
      date: DateTime.parse(json['date']),
      totalSales: json['total_sales'].toDouble(),
      totalOrders: json['total_orders'],
      averageOrderValue: json['average_order_value'].toDouble(),
      salesByCategory: Map<String, double>.from(json['sales_by_category']),
      topSellingItems: (json['top_selling_items'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'total_sales': totalSales,
      'total_orders': totalOrders,
      'average_order_value': averageOrderValue,
      'sales_by_category': salesByCategory,
      'top_selling_items': topSellingItems.map((item) => item.toJson()).toList(),
    };
  }
}

class InventoryReport {
  final DateTime date;
  final List<InventoryItem> items;

  InventoryReport({
    required this.date,
    required this.items,
  });

  factory InventoryReport.fromJson(Map<String, dynamic> json) {
    return InventoryReport(
      date: DateTime.parse(json['date']),
      items: (json['items'] as List)
          .map((item) => InventoryItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class InventoryItem {
  final String menuItemId;
  final String name;
  final int currentStock;
  final int minStock;
  final bool isLowStock;

  InventoryItem({
    required this.menuItemId,
    required this.name,
    required this.currentStock,
    required this.minStock,
    required this.isLowStock,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      menuItemId: json['menu_item_id'],
      name: json['name'],
      currentStock: json['current_stock'],
      minStock: json['min_stock'],
      isLowStock: json['is_low_stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItemId,
      'name': name,
      'current_stock': currentStock,
      'min_stock': minStock,
      'is_low_stock': isLowStock,
    };
  }
}
