import 'package:cloud_firestore/cloud_firestore.dart';

class Avaliation {

  Avaliation();
  
  Avaliation.fromDocument(DocumentSnapshot d) {
    id = d.documentID;
    text = d.data['text'] as String;
    grade = d.data['grade'] as int;
    user = d.data['user'] as String;
  }

  final Firestore firestore = Firestore.instance;


  String id;
  String text;
  int grade;
  String user;

  Future<void> save(String storeId, Avaliation avaliation) async {

    final Map<String, dynamic> data = {
      'text': avaliation.text,
      'grade': avaliation.grade,
      'user': avaliation.user,
    };
    
    if(id == null) {
     final doc = await firestore.collection('stores/$storeId/avaliations').add(data);
     id = doc.documentID;
    } else {
      firestore.document('stores/$storeId/avaliations/$id').updateData(data);
    }
  }



}