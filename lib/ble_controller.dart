// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';

// class BleController extends GetxController {
//   FlutterBlue ble = FlutterBlue.instance;
//   var isScanning = false.obs;
//   var connectedDevice = Rx<BluetoothDevice?>(null);
//   final isConnecting = false.obs;
//   final service = <BluetoothService>[].obs;
//   var rpm = 0.obs;
//   var response = ''.obs;
//   BluetoothCharacteristic? _writeCharacteristic;
//   BluetoothCharacteristic? _notifyCharacteristic;

//   Future scanDevice() async {
//     if (await Permission.bluetoothScan.request().isGranted) {
//       if (await Permission.bluetoothConnect.request().isGranted) {
//         isScanning(true);
//         ble.startScan(
//           timeout: const Duration(seconds: 5),
//         );
//         await Future.delayed(const Duration(seconds: 5));
//         ble.stopScan();
//         isScanning(false);
//       }
//     }
//   }

//   Stream<List<ScanResult>> get scanResult => ble.scanResults;

//   Future<void> connectToDevice(BluetoothDevice device) async {
//     isConnecting(true);
//     await device.connect();
//     connectedDevice.value = device;
//     isConnecting(false);
//     List<BluetoothService> discoveredServices = await device.discoverServices();
//     service.value = discoveredServices;
//     // Find the correct characteristics
//     for (var serv in service) {
//       for (var characteristic in serv.characteristics) {
//         if (characteristic.properties.write) {
//           _writeCharacteristic = characteristic;
//         }
//         if (characteristic.properties.notify) {
//           _notifyCharacteristic = characteristic;
//           await _notifyCharacteristic!.setNotifyValue(true);
//           _notifyCharacteristic!.value.listen((value) {
//             if (value.length >= 4) {
//               // Parsing RPM data
//               int rpmValue = ((value[2] * 256) + value[3]) ~/ 4;
//               rpm.value = rpmValue;
//             }
//           });
//         }
//       }
//       sendRPMCommand();
//     }
//   }

// void sendRPMCommand() async {
//   if (_writeCharacteristic != null) {
//     // Send the PID command for RPM
//     List<int> rpmCommand = [0x01, 0x0C];
//     await _writeCharacteristic!.write(rpmCommand, withoutResponse: true);
//   }
// }

//   void sendRPMCommandManually() async {
//     if (_writeCharacteristic != null) {
//       // Send the PID command for RPM
//       List<int> rpmCommand = [0x01, 0x0C];
//       print("Sending RPM command: $rpmCommand");
//       await _writeCharacteristic!.write(rpmCommand, withoutResponse: false);

//       // Listen for response
//       await Future.delayed(Duration(seconds: 2)); // Adjust delay as needed
//       print("Received response: ${response.value}");
//     } else {
//       print("Write characteristic not found");
//     }
//   }
// }

import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  FlutterBlue ble = FlutterBlue.instance;
  var isScanning = false.obs;
  var connectedDevice = Rx<BluetoothDevice?>(null);
  final isConnecting = false.obs;
  final service = <BluetoothService>[].obs;
  var rpm = 0.obs;
  var response = ''.obs;
  BluetoothCharacteristic? _notifyCharacteristic;

  final String targetServiceUUID =
      "0000ffff-0000-1000-8000-00805f9b34fb"; // UUID layanan
  final String notifyCharacteristicUUID =
      "0000fff1-0000-1000-8000-00805f9b34fb"; // UUID karakteristik notify

  Future scanDevice() async {
    if (await Permission.bluetoothScan.request().isGranted) {
      if (await Permission.bluetoothConnect.request().isGranted) {
        isScanning(true);
        ble.startScan(timeout: const Duration(seconds: 10));
        await Future.delayed(Duration(seconds: 10));
        ble.stopScan();
        isScanning(false);
      }
    }
  }

  Stream<List<ScanResult>> get scanResult => ble.scanResults;

  Future<void> connectToDevice(BluetoothDevice device) async {
    isConnecting(true);
    await device.connect();
    connectedDevice.value = device;
    isConnecting(false);

    List<BluetoothService> discoveredServices = await device.discoverServices();
    service.value = discoveredServices;

    for (var serv in service) {
      if (serv.uuid.toString() == targetServiceUUID) {
        print('Target Service Found: ${serv.uuid}');
        for (var characteristic in serv.characteristics) {
          print('Characteristic UUID: ${characteristic.uuid}');
          if (characteristic.uuid.toString() == notifyCharacteristicUUID) {
            _notifyCharacteristic = characteristic;
            print('Notify Characteristic Found: ${characteristic.uuid}');
            await _notifyCharacteristic!.setNotifyValue(true);
            _notifyCharacteristic!.value.listen((value) {
              print('Received Value: $value');
              if (value.isNotEmpty && value.length >= 4) {
                // Parsing RPM data
                int rpmValue = ((value[2] * 256) + value[3]) ~/ 4;
                rpm.value = rpmValue;
                print('Parsed RPM Value: $rpmValue');
              } else {
                print('Invalid RPM data received.');
              }
            });
          }
        }
      }
    }
  }
}
