import 'package:flutter/material.dart';
import 'package:lojavirtual/helpers/validators.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        key: scaffoldKey,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color.fromARGB(255, 128, 53, 73)),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 242, 196, 56),
          title: const Text(
              "Entrar",
            style: TextStyle(color: Color.fromARGB(255, 128, 53, 73)),
          ),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed('/signup');
                },
                textColor: Color.fromARGB(255, 128, 53, 73),
                child: const Text(
                  'CRIAR CONTA',
                  style: TextStyle(fontSize: 14),
                ))
          ],
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
                      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
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
                            // SizedBox(height: 200, width: 200,child: Image.network("https://i.ibb.co/MM0h6t8/logo-app.png")),
                            TextFormField(
                              controller: emailController,
                              enabled: !userManager.loading,
                              decoration: const InputDecoration(hintText: "E-mail",),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              validator: (email){
                                if(!emailValid(email)){
                                  return "E-mail Inválido";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16,),
                            TextFormField(
                              controller: passController,
                              enabled: !userManager.loading,
                              decoration: const InputDecoration(hintText: "Senha"),
                              autocorrect: false,
                              obscureText: true,
                              validator: (pass){
                                if(pass.isEmpty || pass.length <6){
                                  return "Senha Inválida";
                                }
                                return null;
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FlatButton(
                                onPressed: (){
                                  if(emailController.text.isEmpty){
                                    scaffoldKey.currentState.showSnackBar(
                                      const SnackBar(
                                        content: Text("Insira seu email para recuperação!"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    userManager.recoverPass(emailController.text);
                                    scaffoldKey.currentState.showSnackBar(
                                        const SnackBar(
                                          content: Text("Confira seu email!"),
                                          backgroundColor: Colors.greenAccent,
                                        ),
                                    );

                                  }
                                },
                                padding: EdgeInsets.zero,
                                child: const Text(
                                    "Esqueci minha senha"
                                ),
                              ),
                            ),
                            const SizedBox(height: 16,),
                            RaisedButton(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onPressed: userManager.loading ? null : (){
                                if(formKey.currentState.validate()){
                                  userManager.signIn(
                                    user: User(
                                      email: emailController.text,
                                      password: passController.text,
                                    ),
                                    onFail: (e){
                                      scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          content: Text("Falha ao entrar: $e"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    },
                                    onSucess: (){

                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                              },
                              color: const Color.fromARGB(255, 128, 53, 73),
                              disabledColor: const Color.fromARGB(255, 128, 53, 73).withAlpha(100),
                              textColor: Colors.white,
                              child: userManager.loading ?
                              const CircularProgressIndicator(
                               valueColor: AlwaysStoppedAnimation(Colors.white),
                              ):
                              const Text(
                                "Entrar",
                                style: TextStyle(
                                    fontSize: 15
                                ),
                              ),
                            ),
                            /*SignInButton(
                              Buttons.Facebook,
                              text: 'Entrar com Facebook',
                              onPressed: (){
                                userManager.facebookLogin(
                                  onFail: (e){
                                    scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text("Falha ao entrar: $e"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                  onSuccess: (){
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                            SignInButton(
                              Buttons.Google,
                              text: 'Entrar com Google',
                              onPressed: (){
                                userManager.googleLogin(
                                  onFail: (e){
                                    scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text("Falha ao entrar: $e"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                  onSuccess: (){
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),*/
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