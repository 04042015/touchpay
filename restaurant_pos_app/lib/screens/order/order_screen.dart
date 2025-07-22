import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/menu_card.dart';
import '../../widgets/order_item_tile.dart';
import '../../widgets/app_button.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Food', 'Drinks', 'Desserts'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return IconButton(
                icon: Badge(
                  label: Text('${cartProvider.itemCount}'),
                  isLabelVisible: cartProvider.itemCount > 0,
                  child: const Icon(Icons.shopping_cart),
                ),
                onPressed: () => _showCartBottomSheet(context),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Menu Section
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Category Filter
                _buildCategoryFilter(),
                
                // Menu Items Grid
                Expanded(
                  child: _buildMenuGrid(),
                ),
              ],
            ),
          ),

          // Cart Section
          Container(
            width: 400,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: _buildCartSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuGrid() {
    // This would normally load menu items from a provider
    // For now, showing placeholder structure
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 0, // Will be populated when menu items are loaded
      itemBuilder: (context, index) {
        // return MenuCard(
        //   menuItem: menuItems[index],
        //   onTap: (menuItem) => _addToCart(menuItem),
        // );
        return Container(); // Placeholder
      },
    );
  }

  Widget _buildCartSection() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Column(
          children: [
            // Cart Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.shopping_cart),
                  const SizedBox(width: 8),
                  const Text(
                    'Order Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (cartProvider.itemCount > 0)
                    TextButton(
                      onPressed: () => cartProvider.clearCart(),
                      child: const Text('Clear'),
                    ),
                ],
              ),
            ),

            // Cart Items
            Expanded(
              child: cartProvider.isEmpty
                  ? const Center(
                      child: Text('No items in cart'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: cartProvider.items.length,
                      itemBuilder: (context, index) {
                        final item = cartProvider.items[index];
                        return OrderItemTile(
                          cartItem: item,
                          onQuantityChanged: (quantity) {
                            cartProvider.updateQuantity(index, quantity);
                          },
                          onRemove: () {
                            cartProvider.removeItem(index);
                          },
                        );
                      },
                    ),
            ),

            // Cart Summary and Actions
            if (cartProvider.itemCount > 0) _buildCartSummary(cartProvider),
          ],
        );
      },
    );
  }

  Widget _buildCartSummary(CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal:'),
              Text('\$${cartProvider.subtotal.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 4),
          
          // Tax
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax (${(cartProvider.taxRate * 100).toInt()}%):'),
              Text('\$${cartProvider.tax.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 4),

          // Discount
          if (cartProvider.discount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Discount:'),
                Text('-\$${cartProvider.discount.toStringAsFixed(2)}'),
              ],
            ),

          const Divider(),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${cartProvider.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Save Draft',
                  onPressed: () => _saveDraft(),
                  variant: AppButtonVariant.outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  text: 'Continue',
                  onPressed: () => _continue(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: _buildCartSection(),
          );
        },
      ),
    );
  }

  void _saveDraft() {
    // Implementation for saving draft order
  }

  void _continue() {
    // Implementation for continuing to table selection or payment
  }
}
