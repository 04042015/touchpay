import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/table_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/table_card.dart';
import '../../widgets/app_button.dart';

class TableSelectionScreen extends StatefulWidget {
  const TableSelectionScreen({super.key});

  @override
  State<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends State<TableSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TableProvider>().loadTables();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Table'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Text(
                    '${cartProvider.itemCount} items - \$${cartProvider.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer2<TableProvider, CartProvider>(
        builder: (context, tableProvider, cartProvider, child) {
          if (tableProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (tableProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${tableProvider.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => tableProvider.loadTables(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Select a table to assign this order',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Table Status Legend
                _buildTableStatusLegend(),
                const SizedBox(height: 16),

                // Tables Grid
                Expanded(
                  child: tableProvider.tables.isEmpty
                      ? const Center(
                          child: Text('No tables available'),
                        )
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: tableProvider.tables.length,
                          itemBuilder: (context, index) {
                            final table = tableProvider.tables[index];
                            return TableCard(
                              table: table,
                              isSelected: cartProvider.selectedTableId == table.id,
                              onTap: () => _selectTable(cartProvider, table.id),
                            );
                          },
                        ),
                ),

                // Action Buttons
                if (cartProvider.selectedTableId != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Back to Menu',
                          onPressed: () => context.pop(),
                          variant: AppButtonVariant.outlined,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          text: 'Continue to Payment',
                          onPressed: () => context.push('/payment'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTableStatusLegend() {
    return Row(
      children: [
        _buildLegendItem('Available', Colors.green),
        const SizedBox(width: 16),
        _buildLegendItem('Occupied', Colors.red),
        const SizedBox(width: 16),
        _buildLegendItem('Reserved', Colors.orange),
        const SizedBox(width: 16),
        _buildLegendItem('Cleaning', Colors.grey),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _selectTable(CartProvider cartProvider, String tableId) {
    cartProvider.setSelectedTable(tableId);
  }
}
