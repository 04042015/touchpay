import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/menu_item.dart';

class CartItem {
  final MenuItem menuItem;
  int quantity;
  String? notes;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
    this.notes,
  });

  double get totalPrice => menuItem.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _selectedTableId;
  double _discount = 0.0;
  double _taxRate = 0.1; // 10% tax

  List<CartItem> get items => _items;
  String? get selectedTableId => _selectedTableId;
  double get discount => _discount;
  double get taxRate => _taxRate;

  // Cart calculations
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * _taxRate;
  double get total => subtotal + tax - _discount;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  // Add item to cart
  void addItem(MenuItem menuItem, {int quantity = 1, String? notes}) {
    final existingIndex = _items.indexWhere(
      (item) => item.menuItem.id == menuItem.id && item.notes == notes,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        menuItem: menuItem,
        quantity: quantity,
        notes: notes,
      ));
    }

    notifyListeners();
  }

  // Remove item from cart
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  // Update item quantity
  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < _items.length) {
      if (quantity <= 0) {
        removeItem(index);
      } else {
        _items[index].quantity = quantity;
        notifyListeners();
      }
    }
  }

  // Update item notes
  void updateNotes(int index, String? notes) {
    if (index >= 0 && index < _items.length) {
      _items[index].notes = notes;
      notifyListeners();
    }
  }

  // Clear cart
  void clearCart() {
    _items.clear();
    _selectedTableId = null;
    _discount = 0.0;
    notifyListeners();
  }

  // Set selected table
  void setSelectedTable(String? tableId) {
    _selectedTableId = tableId;
    notifyListeners();
  }

  // Set discount
  void setDiscount(double discount) {
    _discount = discount;
    notifyListeners();
  }

  // Set tax rate
  void setTaxRate(double taxRate) {
    _taxRate = taxRate;
    notifyListeners();
  }

  // Convert cart to order items
  List<OrderItem> toOrderItems() {
    return _items.map((cartItem) {
      return OrderItem(
        id: '', // Will be set by the server
        menuItem: cartItem.menuItem,
        quantity: cartItem.quantity,
        unitPrice: cartItem.menuItem.price,
        notes: cartItem.notes,
      );
    }).toList();
  }

  // Load cart from order (for editing existing orders)
  void loadFromOrder(Order order) {
    clearCart();
    _selectedTableId = order.tableId;

    for (final orderItem in order.items) {
      _items.add(CartItem(
        menuItem: orderItem.menuItem,
        quantity: orderItem.quantity,
        notes: orderItem.notes,
      ));
    }

    // Calculate discount from order totals
    final calculatedSubtotal = subtotal;
    final calculatedTax = calculatedSubtotal * _taxRate;
    _discount = calculatedSubtotal + calculatedTax - order.total;

    notifyListeners();
  }
}
