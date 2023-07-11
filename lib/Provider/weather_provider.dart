
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../Models/models.dart';
import 'api_key.dart';

class WeatherProvider extends ChangeNotifier{
  CurrentModel currentModel = CurrentModel();

  String errorMsg = '';

  Future<void> getCurrentData(Position position ) async {
    final apiUrl = "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$weatherApi";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final jsonbody = json.decode(response.body);

      if(response.statusCode ==200){
        currentModel = CurrentModel.fromJson(jsonbody);
        print(currentModel.main!.temp.toString());
        notifyListeners();
      }else{
        errorMsg = 'Error retrieving weather data.';
      }

    }catch(error){
      throw error;
    }



  }



}