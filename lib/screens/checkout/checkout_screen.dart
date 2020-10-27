import 'package:flutter/material.dart';
import 'package:lojavirtual/common/price_card.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/checkout_manager.dart';
import 'package:lojavirtual/models/credit_card.dart';
import 'package:lojavirtual/screens/checkout/components/cpf_field.dart';
import 'package:lojavirtual/screens/checkout/components/credit_card_widget.dart';
import 'package:lojavirtual/screens/checkout/components/cupom_card.dart';
import 'package:lojavirtual/screens/checkout/components/delivery_payment_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatelessWidget {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final creditCard = context.watch<CreditCard>();
    final cartManager = context.watch<CartManager>();

    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Color.fromARGB(255, 128, 53, 73)),
          title: const Text('Pagamento', style: TextStyle(color: Color.fromARGB(255, 128, 53, 73)),),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Consumer<CheckoutManager>(
            builder: (_, checkoutManager, __) {
              if (checkoutManager.loading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color.fromARGB(255, 128, 53, 73)),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Processando sua entrega...',
                        style: TextStyle(
                          color: Color.fromARGB(255, 128, 53, 73),
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    // if(cartManager.paymentMethod == null)
                    //   CreditCardWidget(creditCard),
                    // if(cartManager.paymentMethod == null)
                    //   CpfField(),
                    DeliveryPaymentCard(),
                    PriceCard(
                      buttonText: 'Finalizar Pedido',
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();

                          checkoutManager.checkout(
                              creditCard: creditCard,
                              onStockFail: () {
                                Navigator.of(context).popUntil(
                                    (route) => route.settings.name == '/cart');
                              },
                              onPayFail: (e){
                                scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('$e'),
                                    backgroundColor: Colors.red,
                                  )
                                );
                              },
                              onSuccess: (order) {
                                Navigator.of(context).popUntil(
                                    (route) => route.settings.name == '/');
                                Navigator.of(context).pushNamed(
                                  '/confirmation',
                                  arguments: order,
                                );
                              }
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


