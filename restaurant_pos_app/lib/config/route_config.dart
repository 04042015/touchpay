import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/order/order_screen.dart';
import '../screens/order/table_selection_screen.dart';
import '../screens/order/payment_screen.dart';
import '../screens/menu/menu_screen.dart';
import '../screens/report/report_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/order',
        name: 'order',
        builder: (context, state) => const OrderScreen(),
      ),
      GoRoute(
        path: '/table-selection',
        name: 'table-selection',
        builder: (context, state) => const TableSelectionScreen(),
      ),
      GoRoute(
        path: '/payment',
        name: 'payment',
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/menu',
        name: 'menu',
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: '/report',
        name: 'report',
        builder: (context, state) => const ReportScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
