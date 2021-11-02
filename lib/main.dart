import 'package:flutter/material.dart';
import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_location/location/location.dart';
import 'package:huawei_location/permission/permission_handler.dart';
import 'package:huawei_map/map.dart' as HMSMap;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _zoom = 12;
  late HMSMap.HuaweiMapController mapController;
  HMSMap.LatLng _center = HMSMap.LatLng(41.012959, 28.997438);

  void _incrementCounter() {
    setState(() async {
      PermissionHandler permissionHandler = PermissionHandler();
// Request location permissions
      try {
        bool status = await permissionHandler.requestLocationPermission();
        // true if permissions are granted; false otherwise

        if (status) {
          FusedLocationProviderClient locationService =
              FusedLocationProviderClient();

          try {
            Location location = await locationService.getLastLocation();
            print(
                "Latitude ${location.latitude} and Longitude:${location.longitude}}");

            HMSMap.LatLng latLng1 =
                HMSMap.LatLng(location.latitude!, location.longitude!);
            HMSMap.CameraUpdate cameraUpdate =
                HMSMap.CameraUpdate.newLatLng(latLng1);
            mapController.animateCamera(cameraUpdate);
            //_center = HMSMap.LatLng(location.latitude!, location.longitude!);
          } catch (e) {
            print(e.toString());
          }
        }
      } catch (e) {
        print(e.toString);
      }
    });
  }

  @override
  void initState() {}

  void _onMapCreated(HMSMap.HuaweiMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: HMSMap.HuaweiMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: HMSMap.CameraPosition(
          target: _center,
          zoom: _zoom,
        ),
        onMapCreated: (_mapController) {
          mapController = _mapController;
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
