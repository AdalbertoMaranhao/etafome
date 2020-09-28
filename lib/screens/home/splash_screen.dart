import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/stores_manager.dart';
import 'package:lojavirtual/screens/base/base_screen.dart';
import 'package:lojavirtual/screens/home/select_city_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  String city;
  @override
  void initState() {
    _loadCity();

    super.initState();
    //mudar duração quando colocar o logo
    Timer(Duration(seconds: 1),()=>Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
      return city != null ? BaseScreen() : SelectCityScreen();
    })));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(20, 26, 50, 1),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor:
          AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }

  Future<void> _loadCity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    city = prefs.getString('city');
  }
}