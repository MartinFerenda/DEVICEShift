import 'dart:async';

import 'package:device_shift/feature/common/sensor_type.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barometer_plugin/flutter_barometer.dart';
import 'package:local_auth/local_auth.dart';
import 'package:location/location.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShowResultsScreen extends StatefulWidget {
  final String title;
  final SensorsType sensorType;

  const ShowResultsScreen({super.key, required this.title, required this.sensorType});

  @override
  State<ShowResultsScreen> createState() => _ShowResultsScreenState();
}

class _ShowResultsScreenState extends State<ShowResultsScreen> {
  StreamSubscription<UserAccelerometerEvent>? _userAccelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeEventSubscription;
  double xAxis = 0;
  double yAxis = 0;
  double zAxis = 0;
  StreamSubscription<int>? _proximityStreamSubscription;
  StreamSubscription<BarometerValue>? _barometerEventSubscription;
  BarometerValue _currentPressure = BarometerValue(0.0);
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool _tempAvailable = false;
  double _temperature = 0;
  double? _latitude = 0;
  double? _longitude = 0;


  void _startAccelerometer() {
    _userAccelerometerSubscription = userAccelerometerEventStream().listen((event) {
      setState(() {
        xAxis = event.x;
        yAxis = event.y;
        zAxis = event.z;
      });
    });
  }

  void _startGyroscope() {
    _gyroscopeEventSubscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      setState(() {
        xAxis = event.x;
        yAxis = event.y;
        zAxis = event.z;
      });
    });
  }

  Future<void> _startProximitySensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    await ProximitySensor.setProximityScreenOff(true)
        .onError((error, stackTrace) {
      if (foundation.kDebugMode) {
        debugPrint("could not enable screen off functionality");
      }
      return null;
    });
    _proximityStreamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
      });
    });
  }

  void _startBarometer() {
    _barometerEventSubscription = FlutterBarometer.currentPressureEvent.listen((event) {
      setState(() {
        _currentPressure = event;
      });
    });
  }

  Future<void> _startFingerprintSensor() async {
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
          ? _SupportState.supported
          : _SupportState.unsupported),
    );
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
            () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
        'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  Future<void> _startTemperatureSensor() async {
    // final environmentSensors = EnvironmentSensors();
    // environmentSensors.temperature.listen((temperature) {
    //   setState(() {
    //     _temperature = temperature;
    //   });
    // });
    // bool tempAvailable;
    //
    // tempAvailable = await environmentSensors
    //     .getSensorAvailable(SensorType.AmbientTemperature);
    //
    // setState(() {
    //   _tempAvailable = tempAvailable;
    // });
  }

  Future<void> _startLocationSensor() async {
    final Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    setState(() {
      _latitude = locationData.latitude;
      _longitude = locationData.longitude;
    });
  }

  @override
  void initState() {
    super.initState();
    switch (widget.sensorType) {
      case SensorsType.accelerometer:
        _startAccelerometer();
        break;
      case SensorsType.gyroscope:
        _startGyroscope();
        break;
      case SensorsType.proximitySensor:
        _startProximitySensor();
        break;
      case SensorsType.barometer:
        _startBarometer();
        break;
      case SensorsType.fingerprintSensor:
        _startFingerprintSensor();
        break;
      case SensorsType.temperatureSensor:
        _startTemperatureSensor();
        break;
      case SensorsType.locationSensor:
        _startLocationSensor();
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_userAccelerometerSubscription != null) {
      _userAccelerometerSubscription?.cancel();
    }
    if (_gyroscopeEventSubscription != null) {
      _gyroscopeEventSubscription?.cancel();
    }
    if (_proximityStreamSubscription != null) {
      _proximityStreamSubscription?.cancel();
    }
    if (_barometerEventSubscription != null) {
      _barometerEventSubscription?.cancel();
    }
  }

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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              (widget.sensorType == SensorsType.accelerometer || widget.sensorType == SensorsType.gyroscope) ?
                Column(
                  children: [
                    Text(
                      "X: ${xAxis.toStringAsFixed(8)}",
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      "Y: ${yAxis.toStringAsFixed(8)}",
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      "Z: ${zAxis.toStringAsFixed(8)}",
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ]
                ) : SizedBox(),
              (widget.sensorType == SensorsType.proximitySensor) ?
                  Text(
                    "Prekrijte zaslon dlanom",
                    style: TextStyle(
                        fontSize: 40,
                    ),
                    textAlign: TextAlign.center,
                  ) : SizedBox(),
              (widget.sensorType == SensorsType.barometer) ?
                Text(
                  '${(_currentPressure.hectpascal * 1000).round() / 1000} hPa',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ) : SizedBox(),
              (widget.sensorType == SensorsType.fingerprintSensor) ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                          ),
                          onPressed: _authenticateWithBiometrics,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(_isAuthenticating
                                  ? 'Cancel'
                                  : 'Autentikacija biometrijom', style: TextStyle(color: Colors.black),),
                              SizedBox(width: 5,),
                              const Icon(Icons.fingerprint, color: Colors.black,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ) : SizedBox(),

              // (_tempAvailable) ? Text("Temperatura: $_temperature") : Text("Senzor temperature nije dostupan!"),
              (widget.sensorType == SensorsType.locationSensor) ? (_latitude != null) ? Text("Geografska širina: $_latitude", style: TextStyle(fontSize: 40,), textAlign: TextAlign.center,) : Text("") : SizedBox(),
              (widget.sensorType == SensorsType.locationSensor) ? (_longitude != null) ? Text("Geografska dužina: $_longitude", style: TextStyle(fontSize: 40,), textAlign: TextAlign.center,) : Text("") : SizedBox(),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
