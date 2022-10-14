import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class LazadaScreen extends StatefulWidget {
  const LazadaScreen({super.key});

  @override
  State<LazadaScreen> createState() => _LazadaScreenState();
}

class _LazadaScreenState extends State<LazadaScreen> {
  var data;
  @override
  void initState() {
    _getCode();
    super.initState();
  }

  _getCode() async {
    Dio _dio = Dio();
    var response = await _dio
        .get("https://auth.lazada.com/oauth/authorize", queryParameters: {
      "response_type": "code",
      "force_auth": true,
      "redirect_uri": "https://www.google.com",
      "client_id": 112922,
    });
    setState(() {
      data = response.data;
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Otorisasi Lazada"),
      ),
      body: Html(
        data: data,
        onLinkTap: (str, context, map, element) {
          print(str);
        },
      ),
    );
  }
}
