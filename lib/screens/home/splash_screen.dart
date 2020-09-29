import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/stores_manager.dart';
import 'package:lojavirtual/screens/base/base_screen.dart';
import 'package:lojavirtual/screens/home/select_city_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
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
    Timer(const Duration(seconds: 1),()=>Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
      return city != null ? BaseScreen() : SelectCityScreen();
    })));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Center(
            child: SizedBox(
              height: 300,
              width: 300,
              child: const Image(image: AssetImage('assets/logo_oficial.png')),
            ),
          ),
          const CircularProgressIndicator(
            valueColor:
            AlwaysStoppedAnimation(Color.fromARGB(255, 128, 53, 73)),
          ),
        ],
      ),
    );
  }

  Future<void> _loadCity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    city = prefs.getString('city');
  }
}