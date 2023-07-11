import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'Provider/weather_provider.dart';

class OpenWeather extends StatefulWidget {
  static const String routeName = '/home';

  @override
  State<OpenWeather> createState() => _OpenWeatherState();
}

class _OpenWeatherState extends State<OpenWeather> {
  late WeatherProvider _provider;
  bool _isInit = true;
  bool _isLoding = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _provider = Provider.of<WeatherProvider>(context);
      _determinePosition().then((position) {
        _provider.getCurrentData(position).then((value) {
          setState(() {
            _isLoding = false;
          });
        });
        // print('lat : ${position.latitude}, lon : ${position.longitude}');
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        actions: [
          Row(children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.search)),
            IconButton(onPressed: (){}, icon: Icon(Icons.settings)),
          ],)
        ],
        title: const Text("Current Weather"),
        centerTitle: true,
      ),

      body: _isLoding
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text('Current Weather : ', style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold)),
              SizedBox(height: 20,),
              Text('${_provider.currentModel.name}, ${_provider.currentModel.sys!.country }', style: TextStyle(fontSize: 23),
              ),
              SizedBox(height: 20,),
              Text(
                '${_provider.currentModel.main!.temp}\u00B0',
                style:const TextStyle(fontSize: 45),
              ),
              SizedBox(height: 20,),
              Text(
                'Feels like ${_provider.currentModel.main!.feelsLike}\u00B0',
                style: const TextStyle(fontSize: 23),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
