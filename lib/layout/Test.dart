
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeCode extends StatefulWidget {
   const NativeCode({Key? key}) : super(key: key);

   @override
   State<NativeCode> createState() => _NativeCodeState();
 }

 class _NativeCodeState extends State<NativeCode> {
   static const platform = MethodChannel('samples.flutter.dev/battery');

// Get battery level.
   String batteryLevel = 'Unknown battery level.';

   Future<void> getBatteryLevel() async {
     String batteryLevel;
     try {
       final int result = await platform.invokeMethod('getBatteryLevel');
       batteryLevel = 'Battery level at $result % .';
     } on PlatformException catch (e) {
       batteryLevel = "Failed to get battery level: '${e.message.toString()}'.";
     }

     setState(() {
       batteryLevel = batteryLevel;
     });
   }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
             ElevatedButton(
               onPressed: getBatteryLevel,
               child: const Text('Get Battery Level'),
             ),
             Text(batteryLevel),
           ],
         ),
       ),
     );
   }
 }
