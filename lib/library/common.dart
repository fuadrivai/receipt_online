import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';

class Common {
  static final oCcy = NumberFormat("#,##0", "en_US");
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
          '#ff6666', "", true, ScanMode.BARCODE);
      if (barcodeScaner != "-1") {
        onSuccess(barcodeScaner);
      }
    } on PlatformException {
      barcodeScaner = 'Failed to get platform version.';
    }
  }

  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.limited) {
      return true;
    } else if (status == PermissionStatus.permanentlyDenied) {
      return false;
    } else if (status == PermissionStatus.restricted) {
      return true;
    } else {
      return false;
    }
  }

  static TransactionOnline mappingTempTransaction(TransactionOnline e) {
    TransactionOnline transaction = TransactionOnline(
      createTimeOnline: e.createTimeOnline,
      updateTimeOnline: e.updateTimeOnline,
      messageToSeller: e.messageToSeller,
      orderNo: e.orderNo,
      orderStatus: e.orderStatus,
      trackingNumber: e.trackingNumber,
      deliveryBy: e.deliveryBy,
      pickupBy: e.pickupBy,
      totalAmount: e.totalAmount,
      totalQty: e.totalQty,
      status: e.status,
      onlineShopId: e.onlineShopId,
      orderId: e.orderId,
      productPicture: e.productPicture,
      packagePicture: e.packagePicture,
      items: e.items,
      shippingProviderType: e.shippingProviderType,
      scanned: e.scanned,
      showRequest: e.showRequest,
    );

    return transaction;
  }
}
