import 'package:device_shift/feature/common/sensor_type.dart';
import 'package:flutter/material.dart';

import 'feature/show_results/show_results_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Demo app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Colors.greenAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(padding: EdgeInsetsGeometry.all(10),
                          child: Column(
                            children: [
                              Icon(Icons.edgesensor_high_outlined, color: Colors.greenAccent, size: 80,),
                              Text("AKCELEROMETAR"),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShowResultsScreen(title: "Podaci akcelerometra", sensorType: SensorsType.accelerometer))
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Colors.greenAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(padding: EdgeInsetsGeometry.all(10),
                          child: Column(
                            children: [
                              Icon(Icons.screen_rotation_outlined, color: Colors.greenAccent, size: 80,),
                              Text("ŽIROSKOP"),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShowResultsScreen(title: "Podaci žiroskopa", sensorType: SensorsType.gyroscope))
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20, height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Colors.greenAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(padding: EdgeInsetsGeometry.all(10),
                          child: Column(
                            children: [
                              Icon(Icons.screen_lock_portrait_outlined, color: Colors.greenAccent, size: 80,),
                              Text("SENZOR BLIZINE"),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShowResultsScreen(title: "Podaci senzora blizine", sensorType: SensorsType.proximitySensor))
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Colors.greenAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(padding: EdgeInsetsGeometry.all(10),
                          child: Column(
                            children: [
                              Icon(Icons.compress_outlined, color: Colors.greenAccent, size: 80,),
                              Text("BAROMETAR"),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShowResultsScreen(title: "Podaci barometra", sensorType: SensorsType.barometer))
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20, height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Colors.greenAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(padding: EdgeInsetsGeometry.all(10),
                          child: Column(
                            children: [
                              Icon(Icons.fingerprint_outlined, color: Colors.greenAccent, size: 60,),
                              Text("SENZOR OTISKA PRSTA", textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShowResultsScreen(title: "Podaci senzora otiska prsta", sensorType: SensorsType.fingerprintSensor))
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Colors.greenAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(padding: EdgeInsetsGeometry.all(10),
                          child: Column(
                            children: [
                              Icon(Icons.location_on_outlined, color: Colors.greenAccent, size: 80,),
                              Text("SENZOR LOKACIJE"),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShowResultsScreen(title: "Podaci senzora lokacije", sensorType: SensorsType.locationSensor))
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
