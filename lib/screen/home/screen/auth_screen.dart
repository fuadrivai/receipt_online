import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/screen/home/bloc/lazada_auth_bloc.dart';
import 'package:receipt_online_shop/widget/custom_appbar.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class LazadaAuthScreen extends StatefulWidget {
  const LazadaAuthScreen({super.key});

  @override
  State<LazadaAuthScreen> createState() => _LazadaAuthScreenState();
}

class _LazadaAuthScreenState extends State<LazadaAuthScreen> {
  late final WebViewController _controller;

  PlatformWebViewControllerCreationParams params =
      const PlatformWebViewControllerCreationParams();
  @override
  void initState() {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams
          .fromPlatformWebViewControllerCreationParams(
        params,
      );
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams
          .fromPlatformWebViewControllerCreationParams(
        params,
      );
    }

    final WebViewController webViewController =
        WebViewController.fromPlatformCreationParams(params)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..clearCache()
          ..canGoBack();

    _controller = webViewController;
    context.read<LazadaAuthBloc>().add(const OnGetLink());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppbar(
          title: "Lazada Authorization",
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: BlocBuilder<LazadaAuthBloc, LazadaAuthState>(
        builder: (context, state) {
          if (state.loading) {
            return const LoadingScreen();
          }
          if (state.isError) {
            return Center(
              child: Text(state.errorMessage ?? "Something went wrong..."),
            );
          }
          return WebViewWidget(
            controller: _controller
              ..loadRequest(Uri.parse(state.link ?? "https://lazada.co.id"))
              ..addJavaScriptChannel("getToken", onMessageReceived: (po) {
                print(po);
              }),
          );
        },
      ),
    );
  }
}
