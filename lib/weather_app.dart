import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String _location = 'Tallinn';
  String _temperature = '';
  String _condition = '';

  Future<void> _getWeatherData(String location) async {
    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?name=$location&hourly=temperature_2m,weathercode'));
    final data = jsonDecode(response.body);

    setState(() {
      _location = location;
      _temperature = data['hourly']['temperature_2m'][0].toString();
      _condition = data['hourly']['weathercode'][0]['description'];
    });
  }

  @override
  void initState() {
    super.initState();
    _getWeatherData(_location);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current temperature in $_location:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              _temperature + '°C',
              style: TextStyle(fontSize: 50),
            ),
            SizedBox(height: 10),
            Text(
              'Current condition: $_condition',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _getWeatherData(_location),
              child: Text('Refresh'),
            ),
            SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter a location',
              ),
              onSubmitted: (value) async {
                await _getWeatherData(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}