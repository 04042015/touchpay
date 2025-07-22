import '../models/order.dart';
import '../models/menu_item.dart';
import 'api_service.dart';

class OrderService {
  // Create new order
  static Future<Order> createOrder(String tableId, List<OrderItem> items) async {
    try {
      final response = await ApiService.post('orders', {
        'table_id': tableId,
        'items': items.map((item) => item.toJson()).toList(),
      });
      return Order.fromJson(response['order']);
    } catch (e) {
      throw OrderException('Failed to create order: $e');
    }
  }

  // Get order by ID
  static Future<Order> getOrder(String orderId) async {
    try {
      final response = await ApiService.get('orders/$orderId');
      return Order.fromJson(response['order']);
    } catch (e) {
      throw OrderException('Failed to get order: $e');
    }
  }

  // Get orders by table
  static Future<List<Order>> getOrdersByTable(String tableId) async {
    try {
      final response = await ApiService.get('orders?table_id=$tableId');
      return (response['orders'] as List)
          .map((order) => Order.fromJson(order))
          .toList();
    } catch (e) {
      throw OrderException('Failed to get orders by table: $e');
    }
  }

  // Update order status
  static Future<Order> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      final response = await ApiService.put('orders/$orderId/status', {
        'status': status.name,
      });
      return Order.fromJson(response['order']);
    } catch (e) {
      throw OrderException('Failed to update order status: $e');
    }
  }

  // Add items to existing order
  static Future<Order> addItemsToOrder(
    String orderId,
    List<OrderItem> items,
  ) async {
    try {
      final response = await ApiService.post('orders/$orderId/items', {
        'items': items.map((item) => item.toJson()).toList(),
      });
      return Order.fromJson(response['order']);
    } catch (e) {
      throw OrderException('Failed to add items to order: $e');
    }
  }

  // Remove item from order
  static Future<Order> removeItemFromOrder(
    String orderId,
    String itemId,
  ) async {
    try {
      final response = await ApiService.delete('orders/$orderId/items/$itemId');
      return Order.fromJson(response['order']);
    } catch (e) {
      throw OrderException('Failed to remove item from order: $e');
    }
  }

  // Cancel order
  static Future<Order> cancelOrder(String orderId) async {
    try {
      final response = await ApiService.put('orders/$orderId/cancel', {});
      return Order.fromJson(response['order']);
    } catch (e) {
      throw OrderException('Failed to cancel order: $e');
    }
  }

  // Process payment
  static Future<Order> processPayment(
    String orderId,
    double amount,
    String paymentMethod,
  ) async {
    try {
      final response = await ApiService.post('orders/$orderId/payment', {
        'amount': amount,
        'payment_method': paymentMethod,
      });
      return Order.fromJson(response['order']);
    } catch (e) {
      throw OrderException('Failed to process payment: $e');
    }
  }

  // Get active orders
  static Future<List<Order>> getActiveOrders() async {
    try {
      final response = await ApiService.get('orders?status=active');
      return (response['orders'] as List)
          .map((order) => Order.fromJson(order))
          .toList();
    } catch (e) {
      throw OrderException('Failed to get active orders: $e');
    }
  }
}

class OrderException implements Exception {
  final String message;
  OrderException(this.message);

  @override
  String toString() => 'OrderException: $message';
}
