import 'package:flutter/material.dart';
import 'package:lojavirtual/models/stores_manager.dart';
import 'package:lojavirtual/screens/base/base_screen.dart';
import 'package:lojavirtual/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class SelectCityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storeManager = context.watch<StoresManager>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecione a sua cidade"),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              RaisedButton(
                color: Colors.green,
                child: const Text("Mauriti"),
                onPressed: (){
                  storeManager.setCity("Mauriti");
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                    return BaseScreen();
                  }));
                },
              ),
              RaisedButton(
                color: Colors.green,
                child: const Text("Trindade"),
                onPressed: (){
                  storeManager.setCity("Trindade");
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                    return BaseScreen();
                  }));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}