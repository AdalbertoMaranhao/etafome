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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 128, 53, 73)),
        title: const Text("Selecione a sua cidade", style: TextStyle(color: Color.fromARGB(255, 128, 53, 73)),),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 255, 255, 230)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: RaisedButton(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: (){
                            storeManager.setCity("Mauriti");
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                              return BaseScreen();
                            }));
                          },
                          child: const Text(
                            "Mauriti",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: RaisedButton(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: (){
                            storeManager.setCity("Trindade");
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                              return BaseScreen();
                            }));
                          },
                          child: const Text(
                            "Trindade",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  FlatButton(
                      onPressed: (){
                        //Navigator.of(context).pushReplacementNamed('/indication');
                      },
                      textColor: const Color.fromARGB(255, 128, 53, 73),
                      child: const Text(
                        'Não achou a sua cidade?\nleva a fente prai!',
                        style: TextStyle(
                            fontSize: 16,
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}