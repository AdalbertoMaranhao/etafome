

import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/common/empty_card.dart';
import 'package:lojavirtual/models/home_manager.dart';
import 'package:lojavirtual/models/page_manager.dart';
import 'package:lojavirtual/models/stores_manager.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'components/add_section_widget.dart';
import 'components/section_category.dart';
import 'components/section_list.dart';
import 'components/section_staggered.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final storeManager = context.watch<StoresManager>();


    final String dropDownValue = storeManager.city;
    final List<String> dropDownList = ['Mauriti', 'Trindade'];


    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: <Widget>[
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
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                iconTheme: const IconThemeData(color: Color.fromARGB(255, 128, 53, 73)),
                snap: true,
                floating: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: SizedBox(
                    height: 30,
                      width: 130,
                      child: Image(image: AssetImage('assets/logo.png'))),
                  centerTitle: true,
                ),
                actions: <Widget>[
                    // DropdownButtonHideUnderline(
                    //   child: DropdownButton<String>(
                    //     value: dropDownValue,
                    //     style: const TextStyle(color: Color.fromARGB(255, 128, 53, 73)),
                    //     iconEnabledColor: Colors.white,
                    //     dropdownColor: Colors.white,
                    //     icon: const Icon(Icons.location_on, color: Color.fromARGB(255, 128, 53, 73),),
                    //     iconSize: 20,
                    //     elevation: 16,
                    //
                    //     onChanged: (String newValue) {
                    //       storeManager.getStoresCity(newValue);
                    //     },
                    //
                    //     items: dropDownList
                    //         .map<DropdownMenuItem<String>>((String value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value),
                    //       );
                    //     }).toList(),),
                    // ),

                  Consumer2<UserManager, HomeManager>(
                    builder: (_, userManager, homeManager, __){
                      if(userManager.adminEnabled && !homeManager.loading){
                        if(homeManager.editing){
                          return PopupMenuButton(
                            onSelected: (e){
                              if(e == 'Salvar'){
                                homeManager.saveEditing();
                              } else {
                                homeManager.discardEditing();
                              }
                            },
                            itemBuilder: (_){
                              return ['Salvar', 'Descartar'].map((e){
                                return PopupMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList();
                            },
                          );
                        } else {
                          return IconButton(
                            icon: const Icon(Icons.edit, color: Color.fromARGB(255, 128, 53, 73),),
                            onPressed: homeManager.enterEditing,
                          );
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
              Consumer<HomeManager>(
                builder: (_, homeManager, __) {
                  if(homeManager.loading){
                    return const SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Colors.transparent,
                      ),
                    );
                  }

                  final List<Widget> children =
                  homeManager.sections.map<Widget>(
                          (section) {
                        //verificacao de cidade
                        if((section.city == storeManager.city) || section.city == "todos") {
                          switch(section.type){
                            case 'categorys':
                              return SectionCategory(section);
                            case 'List':
                              return SectionList(section);
                            case 'Staggered':
                              return SectionStaggered(section);
                            default:
                              return Container();
                          }
                        }
                        return Container();
                      }
                  ).toList();

                  if(homeManager.editing) {
                    children.add(AddSectionWidget(homeManager, dropDownValue));
                  }
                  return SliverList(
                    delegate: SliverChildListDelegate(children),
                  );
                },
              ),

            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 128, 53, 73),
        foregroundColor: Colors.white,
        onPressed: () async {
          Navigator.of(context).pushNamed('/cart');
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
