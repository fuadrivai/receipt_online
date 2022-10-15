import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Common {
  static modalInfo(BuildContext context,
      {String? message, required String title, Icon? icon}) {
    showDialog(
      context: context,
      builder: (__) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Divider(height: 2, thickness: 3),
                icon ??
                    const FaIcon(
                      FontAwesomeIcons.circleXmark,
                      color: Colors.red,
                      size: 50,
                    ),
                Text(
                  message ?? "Message",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  static Future<void> scanBarcodeNormal(BuildContext context,
      {required Function onSuccess}) async {
    String barcodeScaner;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScaner = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (barcodeScaner != "-1") {
        onSuccess(barcodeScaner);
      }
    } on PlatformException {
      barcodeScaner = 'Failed to get platform version.';
    }
  }
}
