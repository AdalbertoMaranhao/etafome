import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:screenshot/screenshot.dart';

class ExportAddressDialog extends StatelessWidget {
  ExportAddressDialog({this.address, this.user, this.deliveryMethod, this.payment});

  final Address address;
  final String payment;
  final String user;
  final String deliveryMethod;

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dados de Entrega'),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          child: Text(
            'Cliente: ${user}\n'
            '${payment}\n'
            'Entrega: ${deliveryMethod}\n'
            '${address.street}, ${address.number}, ${address.complement}\n'
            '${address.district}\n'
            '${address.city}/${address.state}\n'
            '${address.zipCode}',
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
      actions: <Widget>[
        FlatButton(
          onPressed: () async{
            Navigator.of(context).pop();
            final file = await screenshotController.capture();
            await GallerySaver.saveImage(file.path);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Exportar'),
        ),
      ],
    );
  }
}