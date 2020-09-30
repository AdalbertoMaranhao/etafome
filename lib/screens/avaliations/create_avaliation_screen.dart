import 'package:flutter/material.dart';
import 'package:lojavirtual/models/avaliation_manager.dart';
import 'package:lojavirtual/models/avalition.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CreateAvaliationScreen extends StatefulWidget {

  CreateAvaliationScreen(this.storeId);

  final String storeId;

  @override
  _CreateAvaliationScreenState createState() => _CreateAvaliationScreenState();
}

class _CreateAvaliationScreenState extends State<CreateAvaliationScreen> {
  final TextEditingController textController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Avaliation aval = Avaliation();

  int grade;

  List<String> notes = ['1', '2', '3', '4', '5',];

  List<String> emojis = ['😥', '😔', '😐', '😁', '😍',];

  int select = 0;

  @override
  Widget build(BuildContext context) {
    final avaliationManager = context.watch<AvaliationManager>();
    final userManager = context.watch<UserManager>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Avaliação"),
      ),
      body: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: <Widget>[
            TextFormField(
              minLines: 1,
              maxLines: 10,
              controller: textController,
              decoration: const InputDecoration(hintText: "O que você achou do seu pedido?"),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16,),
            Text("Dê a sua nota!"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FlatButton(
                    onPressed: (){
                      grade = 1;
                      setState(() {
                        select = 1;
                      });
                    },
                    child: select == 1? Text(
                      emojis[0],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ): Text(
                      notes[0],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: (){
                      grade = 2;
                      setState(() {
                        select = 2;
                      });
                    },
                    child: select == 2 ? Text(
                      emojis[1],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ): Text(
                      notes[1],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: (){
                      grade = 3;
                      setState(() {
                        select = 3;
                      });
                    },
                    child: select == 3 ? Text(
                      emojis[2],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ): Text(
                      notes[2],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: (){
                      grade = 4;
                      setState(() {
                        select = 4;
                      });
                    },
                    child: select == 4? Text(
                      emojis[3],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ): Text(
                      notes[3],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: (){
                      grade = 5;
                      setState(() {
                        select = 5;
                      });
                    },
                    child: select == 5 ? Text(
                      emojis[4],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ): Text(
                      notes[4],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16,),
            RaisedButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: (){
                if(textController.text.isNotEmpty){
                  aval.text = textController.text;
                  aval.grade = grade;
                  aval.user = userManager.user.name;
                  avaliationManager.save(widget.storeId, aval);
                  Navigator.of(context).pop();
                } else{
                  scaffoldKey.currentState.showSnackBar(
                      const SnackBar(
                        content: Text("Diga algo sobre a sua avaliação!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
              },
              color: Theme.of(context).primaryColor,
              disabledColor: Theme.of(context).primaryColor.withAlpha(100),
              textColor: Colors.white,
              child: const Text(
                "Enviar Avaliação",
                style: TextStyle(
                    fontSize: 15
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}