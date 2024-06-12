// import 'package:car_info/ble_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'car info',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("scanner"),
//       ),
//       body: GetBuilder<BleController>(
//         init: BleController(),
//         builder: (BleController controller) {
//           return Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Obx(
//                     () => Text(
//                       "Connectto:${controller.connectedDevice.toString()}",
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Obx(
//                     () => Text(
//                       "service:${controller.service.length}",
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Obx(
//                     () => Text(
//                       "Rpm:${controller.rpm.toString()}",
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Obx(
//                     () => Text(
//                       controller.response.value,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       controller.sendRPMCommandManually();
//                     },
//                     child: const Text("send"),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       controller.scanDevice();
//                       showModalBottomSheet(
//                         context: context,
//                         builder: (context) {
//                           return StreamBuilder(
//                             stream: controller.scanResult,
//                             builder: (context, snapshot) {
//                               return Obx(() {
//                                 if (controller.isScanning.value) {
//                                   return const Center(
//                                       child: CircularProgressIndicator());
//                                 } else {
//                                   if (snapshot.hasData) {
//                                     if (snapshot.data!.isNotEmpty) {
//                                       return ListView.builder(
//                                         itemCount: snapshot.data!.length,
//                                         itemBuilder: (context, index) {
//                                           final data = snapshot.data![index];
//                                           return GestureDetector(
//                                             onTap: () {
//                                               controller
//                                                   .connectToDevice(data.device);
//                                               if (Navigator.canPop(context)) {
//                                                 Navigator.pop(context);
//                                               }
//                                             },
//                                             child: ListTile(
//                                               title: Text(
//                                                 data.device.name.isEmpty
//                                                     ? "Tanpa Nama"
//                                                     : data.device.name,
//                                               ),
//                                               subtitle: Text(
//                                                 data.device.id.id,
//                                               ),
//                                               trailing:
//                                                   Text(data.rssi.toString()),
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     } else {
//                                       if (controller.isScanning.value) {
//                                         return const Center(
//                                           child: CircularProgressIndicator(),
//                                         );
//                                       } else {
//                                         return const Center(
//                                           child: Text("tidak ditemukan device"),
//                                         );
//                                       }
//                                     }
//                                   } else {
//                                     return const Center(
//                                       child: Text("tidak ditemukan device"),
//                                     );
//                                   }
//                                 }
//                               });
//                             },
//                           );
//                         },
//                       );
//                     },
//                     child: const Text("Scan"),
//                   ),
//                 ],
//               ),
//               Obx(() {
//                 if (controller.isConnecting.value) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 return Container();
//               }),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:car_info/ble_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Info',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner"),
      ),
      body: GetBuilder<BleController>(
        init: BleController(),
        builder: (BleController controller) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Obx(
                    () => Text(
                      "Connected to: ${controller.connectedDevice.value?.name ?? 'Not connected'}",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => Text(
                      "Service: ${controller.service.length}",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => Text(
                      "RPM: ${controller.rpm.value}",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => Text(
                      controller.response.value,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.scanDevice();
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return StreamBuilder(
                            stream: controller.scanResult,
                            builder: (context, snapshot) {
                              return Obx(() {
                                if (controller.isScanning.value) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  if (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty) {
                                    return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final data = snapshot.data![index];
                                        return GestureDetector(
                                          onTap: () {
                                            controller
                                                .connectToDevice(data.device);
                                            if (Navigator.canPop(context)) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: ListTile(
                                            title: Text(
                                              data.device.name.isEmpty
                                                  ? "Tanpa Nama"
                                                  : data.device.name,
                                            ),
                                            subtitle: Text(data.device.id.id),
                                            trailing:
                                                Text(data.rssi.toString()),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return const Center(
                                      child: Text("Tidak ditemukan device"),
                                    );
                                  }
                                }
                              });
                            },
                          );
                        },
                      );
                    },
                    child: const Text("Scan"),
                  ),
                ],
              ),
              Obx(() {
                if (controller.isConnecting.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Container();
              }),
            ],
          );
        },
      ),
    );
  }
}
