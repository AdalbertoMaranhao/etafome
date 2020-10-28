//import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditCard extends ChangeNotifier{

  CreditCard(){
    getCreditCard();
  }

  String number;
  String holder;
  String expirationDate;
  String securityCode;
  String brand;

  void setHolder(String name) {
    holder = name;
    notifyListeners();
  }
  void setExpirationDate(String date) {
    expirationDate = date;
    notifyListeners();
  }
  void setCVV(String cvv) {
    securityCode = cvv;
    notifyListeners();
  }

  void setNumber(String number) {
    this.number = number;
    //brand = detectCCType(number.replaceAll(' ', '')).toString().toUpperCase().split(".").last;
    notifyListeners();
  }


  Map<String, dynamic> toJson() {
    return {
      'cardNumber': number.replaceAll(' ', ''),
      'holder': holder,
      'expirationDate': expirationDate,
      'securityCode': securityCode,
      'brand': brand,
    };
  }

  Future<void> getCreditCard() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setHolder(prefs.getString('cardName') ?? "");
    setNumber(prefs.getString('cardNumber') ?? "");
    setExpirationDate(prefs.getString('cardDate') ?? "");
    setCVV(prefs.getString('cardCVV') ?? "");
  }


  @override
  String toString() {
    return 'CreditCard{number: $number, holder: $holder, expirationDate: $expirationDate, securityCode: $securityCode, brand: $brand}';
  }
}