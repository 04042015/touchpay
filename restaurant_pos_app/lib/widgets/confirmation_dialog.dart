import 'package:flutter/material.dart';
import 'app_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? 
                  (isDestructive ? Colors.red : Theme.of(context).colorScheme.primary),
              size: 24,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: [
        AppButton(
          text: cancelText,
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop(false);
          },
          variant: AppButtonVariant.outlined,
        ),
        const SizedBox(width: 8),
        AppButton(
          text: confirmText,
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
          color: isDestructive ? Colors.red : null,
        ),
      ],
    );
  }
}

// Convenience methods for common confirmation dialogs
class ConfirmationDialogHelper {
  static Future<bool?> showDeleteConfirmation(
    BuildContext context, {
    required String itemName,
    String? message,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Delete $itemName',
        message: message ?? 'Are you sure you want to delete this $itemName? This action cannot be undone.',
        confirmText: 'Delete',
        cancelText: 'Cancel',
        icon: Icons.delete_outline,
        isDestructive: true,
      ),
    );
  }

  static Future<bool?> showLogoutConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmationDialog(
        title: 'Logout',
        message: 'Are you sure you want to logout?',
        confirmText: 'Logout',
        cancelText: 'Cancel',
        icon: Icons.logout,
        isDestructive: true,
      ),
    );
  }

  static Future<bool?> showCancelOrderConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmationDialog(
        title: 'Cancel Order',
        message: 'Are you sure you want to cancel this order? All items will be removed.',
        confirmText: 'Cancel Order',
        cancelText: 'Keep Order',
        icon: Icons.cancel_outlined,
        isDestructive: true,
      ),
    );
  }

  static Future<bool?> showClearCartConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmationDialog(
        title: 'Clear Cart',
        message: 'Are you sure you want to clear all items from the cart?',
        confirmText: 'Clear',
        cancelText: 'Cancel',
        icon: Icons.clear_all,
        isDestructive: true,
      ),
    );
  }

  static Future<bool?> showPaymentConfirmation(
    BuildContext context, {
    required double amount,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Process Payment',
        message: 'Process payment of \$${amount.toStringAsFixed(2)}?',
        confirmText: 'Process',
        cancelText: 'Cancel',
        icon: Icons.payment,
      ),
    );
  }
}
