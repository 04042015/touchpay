import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/confirmation_dialog.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'cash';
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'cash', 'name': 'Cash', 'icon': Icons.money},
    {'id': 'card', 'name': 'Credit/Debit Card', 'icon': Icons.credit_card},
    {'id': 'qr', 'name': 'QR Payment', 'icon': Icons.qr_code},
  ];

  @override
  void dispose() {
    _discountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No items in cart',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Order Summary
                Expanded(
                  flex: 2,
                  child: _buildOrderSummary(cartProvider),
                ),

                const SizedBox(width: 24),

                // Payment Details
                Expanded(
                  flex: 1,
                  child: _buildPaymentDetails(cartProvider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Order Items
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.items.length,
                itemBuilder: (context, index) {
                  final item = cartProvider.items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Text(
                          '${item.quantity}x',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.menuItem.name),
                              if (item.notes != null && item.notes!.isNotEmpty)
                                Text(
                                  'Note: ${item.notes}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${item.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Divider(),

            // Order Totals
            _buildTotalRow('Subtotal', '\$${cartProvider.subtotal.toStringAsFixed(2)}'),
            _buildTotalRow('Tax', '\$${cartProvider.tax.toStringAsFixed(2)}'),
            if (cartProvider.discount > 0)
              _buildTotalRow('Discount', '-\$${cartProvider.discount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildTotalRow(
              'Total',
              '\$${cartProvider.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetails(CartProvider cartProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Details',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Payment Method Selection
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ..._paymentMethods.map((method) {
              return RadioListTile<String>(
                title: Row(
                  children: [
                    Icon(method['icon'] as IconData),
                    const SizedBox(width: 8),
                    Text(method['name'] as String),
                  ],
                ),
                value: method['id'] as String,
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              );
            }).toList(),

            const SizedBox(height: 16),

            // Discount Field
            TextField(
              controller: _discountController,
              decoration: const InputDecoration(
                labelText: 'Discount Amount',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final discount = double.tryParse(value) ?? 0.0;
                cartProvider.setDiscount(discount);
              },
            ),

            const SizedBox(height: 16),

            // Notes Field
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Order Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const Spacer(),

            // Process Payment Button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Process Payment',
                onPressed: _isProcessing ? null : () => _processPayment(cartProvider),
                isLoading: _isProcessing,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment(CartProvider cartProvider) async {
    if (cartProvider.selectedTableId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a table first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Process Payment',
        message: 'Are you sure you want to process this payment of \$${cartProvider.total.toStringAsFixed(2)}?',
        confirmText: 'Process',
        cancelText: 'Cancel',
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isProcessing = true;
      });

      try {
        // Simulate payment processing
        await Future.delayed(const Duration(seconds: 2));

        // Clear cart after successful payment
        cartProvider.clearCart();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment processed successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back to home
          context.go('/home');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }
  }
}
