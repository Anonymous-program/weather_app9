
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/weather_provider.dart';
import 'location.dart';

void main(){
  runApp(MyApps());
}
class MyApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          backgroundColor: Colors.purple,
          fontFamily: "Merriweather",
        ),
        title: 'Location Apps',
        home: OpenWeather(),
        routes: {
          OpenWeather.routeName : (context) => OpenWeather(),
        },
      ),
    );
  }
}




