import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_icon_button.dart';
import 'package:lojavirtual/models/option.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/screens/edit_product/components/edit_option.dart';
import 'package:lojavirtual/screens/edit_product/components/option_form.dart';
import 'package:provider/provider.dart';

import 'components/images_form.dart';
import 'components/sizes_form.dart';

class CreateProductScreen extends StatelessWidget {

  CreateProductScreen(this.productStore);

  Product product = Product();
  final String productStore;
  Option option = Option();



  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(productStore);
    product.store = productStore;
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Criar Produto'),
          centerTitle: true,
        ),
        body: Form(
          key: formkey,
          child: ListView(
            children: <Widget>[
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        border: InputBorder.none,
                      ),
                      style:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      validator: (name) {
                        if (name.length < 6) {
                          return 'Titulo muito curto';
                        }
                        return null;
                      },
                      onSaved: (name) {
                        product.name = name;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.price?.toString(),
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: 'Preço',
                        isDense: true,
                        border: InputBorder.none,
                        prefixText: 'R\$ ',
                      ),
                      validator: (price) {
                        if (num.tryParse(price) == null) {
                          return 'Preço inválido';
                        }
                        return null;
                      },
                      onSaved: (price) {
                        product.price = num.tryParse(price);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 16,
                      ),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      validator: (desc) {
                        if (desc.length < 10) {
                          return 'Descrição muito curta';
                        }
                        return null;
                      },
                      onSaved: (desc) {
                        product.description = desc;
                      },
                    ),
                    OptionsForm(product),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Product>(
                      builder: (_, product, __) {
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            color: primaryColor,
                            disabledColor: primaryColor.withAlpha(100),
                            textColor: Colors.white,
                            onPressed: !product.loading
                                ? () async {
                              if (formkey.currentState.validate()) {
                                formkey.currentState.save();
                                await product.save();

                                context.read<ProductManager>()
                                    .update(product);

                                Navigator.of(context).pop();
                              }
                            }
                                : null,
                            child: product.loading
                                ? const CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation(Colors.white),
                            )
                                : const Text(
                              'Salvar',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
