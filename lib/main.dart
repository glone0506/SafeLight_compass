import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibration/vibration.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibration Alert',
      home: VibrationAlert(),
    );
  }
}

class VibrationAlert extends StatefulWidget {
  @override
  _VibrationAlertState createState() => _VibrationAlertState();
}

class _VibrationAlertState extends State<VibrationAlert> {
  late Position _currentPosition;
  double _targetLatitude = 37.485957; // 목표 위치의 위도
  double _targetLongitude = 126.811555; // 목표 위치의 경도

  @override
  void initState() {
    super.initState();
    // 현재 위치를 가져오기 위해 위치 업데이트를 시작합니다.
    _getLocation();
  }

  // 현재 위치를 가져오는 메서드
  void _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      setState(() {
        _currentPosition = position;
      });

      // 방향 체크 및 진동 알림
      _checkDirection();
    } catch (e) {
      print(e);
    }
  }

  // 현재 위치와 목표 위치 간의 방향을 체크하는 메서드
  void _checkDirection() {
    if (_currentPosition != null) {
      double currentLatitude = _currentPosition.latitude;
      double currentLongitude = _currentPosition.longitude;

      // 현재 위치와 목표 위치 간의 방향을 계산합니다.
      double direction = Geolocator.distanceBetween(
          currentLatitude, currentLongitude, _targetLatitude, _targetLongitude);

      // 예를 들어, 방향 변경을 체크하고 진동 알림을 보내는 로직을 추가합니다.
      if (direction > 10.0) {
        // 방향이 10 미터 이상 벗어날 때 진동 알림을 보냅니다.
        Vibration.vibrate(duration: 1000);
      }

      // 다시 위치 업데이트를 시작합니다.
      _getLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vibration Alert'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null)
              Text(
                '현재 위치: ${_currentPosition.latitude}, ${_currentPosition.longitude}',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 목표 위치를 설정합니다. 원하는 위도와 경도로 변경하세요.
                _targetLatitude = 37.12345;
                _targetLongitude = -122.56789;
                _checkDirection();
              },
              child: Text('목표 위치 설정 및 방향 체크 시작'),
            ),
          ],
        ),
      ),
    );
  }
}
