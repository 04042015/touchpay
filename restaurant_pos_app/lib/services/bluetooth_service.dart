import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService {
  static BluetoothConnection? _connection;
  static bool _isConnected = false;

  // Get paired devices
  static Future<List<BluetoothDevice>> getPairedDevices() async {
    try {
      return await FlutterBluetoothSerial.instance.getBondedDevices();
    } catch (e) {
      throw BluetoothException('Failed to get paired devices: $e');
    }
  }

  // Connect to device
  static Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      _isConnected = true;
      return true;
    } catch (e) {
      _isConnected = false;
      throw BluetoothException('Failed to connect to device: $e');
    }
  }

  // Disconnect from device
  static Future<void> disconnect() async {
    try {
      await _connection?.close();
      _connection = null;
      _isConnected = false;
    } catch (e) {
      throw BluetoothException('Failed to disconnect: $e');
    }
  }

  // Check if connected
  static bool get isConnected => _isConnected;

  // Send data to printer
  static Future<void> printData(Uint8List data) async {
    if (!_isConnected || _connection == null) {
      throw BluetoothException('No active Bluetooth connection');
    }

    try {
      _connection!.output.add(data);
      await _connection!.output.allSent;
    } catch (e) {
      throw BluetoothException('Failed to send data: $e');
    }
  }

  // Print receipt
  static Future<void> printReceipt(String receipt) async {
    try {
      final data = Uint8List.fromList(receipt.codeUnits);
      await printData(data);
    } catch (e) {
      throw BluetoothException('Failed to print receipt: $e');
    }
  }

  // Check Bluetooth availability
  static Future<bool> isBluetoothAvailable() async {
    try {
      final state = await FlutterBluetoothSerial.instance.state;
      return state == BluetoothState.STATE_ON;
    } catch (e) {
      return false;
    }
  }

  // Request Bluetooth enable
  static Future<bool> requestEnable() async {
    try {
      final result = await FlutterBluetoothSerial.instance.requestEnable();
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  // Discover devices
  static Stream<BluetoothDiscoveryResult> startDiscovery() {
    return FlutterBluetoothSerial.instance.startDiscovery();
  }

  // Stop discovery
  static Future<void> stopDiscovery() async {
    await FlutterBluetoothSerial.instance.cancelDiscovery();
  }
}

class BluetoothException implements Exception {
  final String message;
  BluetoothException(this.message);

  @override
  String toString() => 'BluetoothException: $message';
}
