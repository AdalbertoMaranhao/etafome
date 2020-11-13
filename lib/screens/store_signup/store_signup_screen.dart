import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtual/helpers/validators.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/store.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class StoreSignUpScreen extends StatefulWidget {

  @override
  _StoreSignUpScreenState createState() => _StoreSignUpScreenState();
}

class _StoreSignUpScreenState extends State<StoreSignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final User user = User();

  final Store store = Store();
  final Address address = Address();

  String emptyValidator(String text) =>
      text.isEmpty ? 'Campo obrigatório' : null;


  @override
  Widget build(BuildContext context) {

    final String dropDownValue = store.category ?? "Pizzarias";
    final List<String> dropDownList = ['Pizzarias', 'Confeitaria', 'Comida', 'Sorveteria', 'Pastelaria'];

    return Scaffold(
      backgroundColor: Colors.transparent,
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 242, 196, 56),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 128, 53, 73)),
        title: const Text('Criar Conta', style: TextStyle(color:Color.fromARGB(255, 128, 53, 73),),),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 242, 196, 56),
                  Color.fromARGB(255, 255, 255, 230)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: ListView(
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    height: 200,
                    width: 200,
                    child: const Image(image: AssetImage('assets/logo_oficial.png'))
                ),
                Form(
                  key: formKey,
                  child: Consumer<UserManager>(
                    builder: (_, userManager, __){
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(hintText: 'Nome Completo'),
                            enabled: !userManager.loading,
                            validator: (name){
                              if(name.isEmpty){
                                return 'Campo obrigatório';
                              }else if(name.trim().split(' ').length <=1){
                                return 'Preencha seu nome completo';
                              }
                              return null;
                            },
                            onSaved: (name) => user.name = name,
                          ),
                          const SizedBox(height: 16,),
                          TextFormField(
                            decoration: const InputDecoration(hintText: 'E-mail'),
                            enabled: !userManager.loading,
                            keyboardType: TextInputType.emailAddress,
                            validator: (email){
                              if(email.isEmpty){
                                return 'Campo obrigatório';
                              }else if(!emailValid(email)){
                                return 'Email invalido';
                              }
                              return null;
                            },
                            onSaved: (email) => user.email = email,
                          ),
                          const SizedBox(height: 16,),
                          TextFormField(
                            decoration: const InputDecoration(hintText: 'Senha'),
                            enabled: !userManager.loading,
                            obscureText: true,
                            validator: (pass){
                              if(pass.isEmpty){
                                return 'Campo obrigatório';
                              }else if(pass.length < 6){
                                return 'Senha muito curta';
                              }
                              return null;
                            },
                            onSaved: (pass) => user.password = pass,
                          ),
                          const SizedBox(height: 16,),
                          TextFormField(
                            decoration: const InputDecoration(hintText: 'Repita a Senha'),
                            enabled: !userManager.loading,
                            obscureText: true,
                            validator: (pass){
                              if(pass.isEmpty){
                                return 'Campo obrigatório';
                              }else if(pass.length < 6){
                                return 'Senha muito curta';
                              }
                              return null;
                            },
                            onSaved: (confirmedPass) => user.confirmedPassword = confirmedPass,
                          ),
                          const SizedBox(height: 16,),
                          TextFormField(
                            decoration: const InputDecoration(hintText: 'Nome Restaurante'),
                            enabled: !userManager.loading,
                            validator: (name){
                              if(name.isEmpty){
                                return 'Campo obrigatório';
                              }else if(name.trim().split(' ').length <=1){
                                return 'Preencha o nome completo';
                              }
                              return null;
                            },
                            onSaved: (name) => store.name = name,
                          ),
                          const SizedBox(height: 16,),
                          TextFormField(
                            decoration: const InputDecoration(hintText: 'Telefone'),
                            enabled: !userManager.loading,
                            keyboardType: TextInputType.phone,
                            validator: (phone){
                              if(phone.isEmpty){
                                return 'Campo obrigatório';
                              }
                              return null;
                            },
                            onSaved: (phone) => store.phone = phone,
                          ),
                          const SizedBox(height: 16,),
                          Row(
                            children: [
                              const Text("Categoria:"),
                              const SizedBox(width: 10,),
                              DropdownButton<String>(
                                value: dropDownValue,
                                style: const TextStyle(color: Colors.black,),
                                iconEnabledColor: Colors.black,
                                dropdownColor: Colors.white,
                                elevation: 16,
                                onChanged: (String newValue) {
                                  setState(() {
                                    store.category = newValue;
                                    print(store.category);
                                  });
                                },

                                items: dropDownList
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),),
                            ],
                          ),
                          const SizedBox(height: 16,),
                          const Text("Endereço do Restaurante"),
                          Divider(),
                          TextFormField(
                            enabled: !userManager.loading,
                            //initialValue: store.address.street,
                            decoration: const InputDecoration(
                              isDense: true,
                              labelText: 'Rua/Avenida',
                              hintText: 'Av. Brasil',
                            ),
                            validator: emptyValidator,
                            onSaved: (t) => address.street = t,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  enabled: !userManager.loading,
                                  //initialValue: store.address.number,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: 'Número',
                                    hintText: '123',
                                  ),
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: emptyValidator,
                                  onSaved: (t) => address.number = t,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: TextFormField(
                                  enabled: !userManager.loading,
                                  //initialValue: store.address.complement,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: 'Ponto de Referência',
                                    hintText: 'Opcional',
                                  ),
                                  onSaved: (t) => address.complement = t,
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            enabled: !userManager.loading,
                            //initialValue: store.address.district,
                            decoration: const InputDecoration(
                              isDense: true,
                              labelText: 'Bairro',
                              hintText: 'Centro',
                            ),
                            validator: emptyValidator,
                            onSaved: (t) => address.district = t,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  enabled: !userManager.loading,
                                  //initialValue: store.address.city,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: 'Cidade',
                                    hintText: 'Campinas',
                                  ),
                                  validator: emptyValidator,
                                  onSaved: (t) => address.city = t,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: TextFormField(
                                  autocorrect: false,
                                  enabled: !userManager.loading,
                                  textCapitalization: TextCapitalization.characters,
                                  //initialValue: store.address.state,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    labelText: 'UF',
                                    hintText: 'SP',
                                    counterText: '',
                                  ),
                                  maxLength: 2,
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return 'Campo obrigatório';
                                    } else if (e.length != 2) {
                                      return 'Inválido';
                                    }
                                    return null;
                                  },
                                  onSaved: (t) => address.state = t,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16,),
                          RaisedButton(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            onPressed: userManager.loading ? null : (){
                              if(formKey.currentState.validate()){
                                formKey.currentState.save();
                                store.media = 5;
                                store.address = address;

                                if(user.password != user.confirmedPassword){
                                  scaffoldKey.currentState.showSnackBar(
                                    const SnackBar(
                                      content: Text("Senhas não coiencidem!"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                userManager.signUP(
                                    user: user,
                                    //store: store,
                                    onSucess: (){
                                      Navigator.of(context).pop();
                                    },
                                    onFail: (e){
                                      scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          content: Text("Falha ao cadastrar: $e"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                );
                              }
                            },
                            color: const Color.fromARGB(255, 128, 53, 73),
                            disabledColor: const Color.fromARGB(255, 128, 53, 73).withAlpha(100),
                            textColor: Colors.white,
                            child: userManager.loading
                                ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                                : const Text(
                              'Criar Conta',
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}