import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // User Profile Section
              _buildSection(
                'User Profile',
                [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user?.name ?? 'Unknown User'),
                    subtitle: Text(user?.email ?? ''),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showEditProfileDialog(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.badge),
                    title: const Text('Role'),
                    subtitle: Text(user?.role.name.toUpperCase() ?? 'UNKNOWN'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Restaurant Settings
              _buildSection(
                'Restaurant Settings',
                [
                  ListTile(
                    leading: const Icon(Icons.store),
                    title: const Text('Restaurant Info'),
                    subtitle: const Text('Name, address, contact details'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showRestaurantInfoDialog(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Tax Settings'),
                    subtitle: const Text('Configure tax rates'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showTaxSettingsDialog(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.table_restaurant),
                    title: const Text('Manage Tables'),
                    subtitle: const Text('Add, edit, or remove tables'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showTableManagementDialog(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // System Settings
              _buildSection(
                'System Settings',
                [
                  ListTile(
                    leading: const Icon(Icons.print),
                    title: const Text('Printer Settings'),
                    subtitle: const Text('Configure receipt printer'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showPrinterSettingsDialog(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.backup),
                    title: const Text('Backup & Sync'),
                    subtitle: const Text('Data backup and synchronization'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showBackupSettingsDialog(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Change Password'),
                    subtitle: const Text('Update your password'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showChangePasswordDialog(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // About Section
              _buildSection(
                'About',
                [
                  const ListTile(
                    leading: Icon(Icons.info),
                    title: Text('App Version'),
                    subtitle: Text('1.0.0'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help & Support'),
                    subtitle: const Text('Get help and contact support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showHelpDialog(),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Logout Button
              AppButton(
                text: 'Logout',
                onPressed: () => _logout(authProvider),
                variant: AppButtonVariant.outlined,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Save',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showRestaurantInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurant Information'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Restaurant Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Save',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showTaxSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tax Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Tax Rate (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Tax Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Save',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showTableManagementDialog() {
    // This would open a more complex dialog or navigate to a dedicated screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Table management feature coming soon'),
      ),
    );
  }

  void _showPrinterSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Printer Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Printer Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Bluetooth Address',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Test Print',
            onPressed: () => Navigator.of(context).pop(),
            variant: AppButtonVariant.outlined,
          ),
          AppButton(
            text: 'Save',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showBackupSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup & Sync'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Auto Backup'),
              trailing: Switch(value: true, onChanged: null),
            ),
            ListTile(
              title: Text('Backup Frequency'),
              subtitle: Text('Daily'),
            ),
            SizedBox(height: 16),
            Text('Last backup: Never'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Backup Now',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Change',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help with the POS system?'),
            SizedBox(height: 16),
            Text('Contact Support:'),
            Text('Email: support@restaurantpos.com'),
            Text('Phone: +1-234-567-8900'),
            SizedBox(height: 16),
            Text('For technical issues, please include your user ID and describe the problem in detail.'),
          ],
        ),
        actions: [
          AppButton(
            text: 'Close',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _logout(AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Logout',
            onPressed: () {
              authProvider.logout();
              Navigator.of(context).pop();
              // Navigation will be handled by auth state changes
            },
          ),
        ],
      ),
    );
  }
}
