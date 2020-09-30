import 'package:flutter/material.dart';
import 'package:lojavirtual/models/store.dart';
import 'package:lojavirtual/models/stores_manager.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

import 'components/body_store_screen.dart';

class StoreScreen extends StatelessWidget{
  const StoreScreen(this.store);

  final Store store;

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<UserManager>().adminEnabled;
    final storesManager = context.watch<StoresManager>();

    Future<bool> _backScreem(){
      Navigator.of(context).pop();
      if(context.read<UserManager>().adminEnabled){
        context.read<UserManager>().adminClear();
      }
    }

    return WillPopScope(
      onWillPop: _backScreem,
      child: DefaultTabController(
          length: 2,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Scaffold(
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Color.fromARGB(255, 128, 53, 73)),
                  backgroundColor: Colors.white,
                  bottom: PreferredSize(preferredSize: const Size(0,85),
                    child: Container(),
                  ),
                ),
                body: BodyStoreScreen(store),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  height: 140,
                  width: 140,
                  child: GestureDetector(
                    onTap: (){
                      if(admin) {
                        if (store.status == StoreStatus.closed) {
                          //store.status = StoreStatus.open;
                          //store.updateStatusStore(StoreStatus.open);
                          storesManager.updateStatusStore(StoreStatus.open, store);
                        } else {
                          //store.status = StoreStatus.closed;
                          //store.status = StoreStatus.closed;
                          //store.updateStatusStore(StoreStatus.closed);
                          storesManager.updateStatusStore(StoreStatus.closed, store);
                        }
                      }
                    },
                    child: Card(
                      elevation: 10,
                        clipBehavior: Clip.antiAlias,
                        child: store.status == StoreStatus.open
                            ? Image.network(store.image)
                            : const Image(image: AssetImage('assets/portao.png')),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}