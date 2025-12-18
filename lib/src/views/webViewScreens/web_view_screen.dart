import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:greycell_app/src/manager/main_model.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final MainModel model;

  WebViewScreen({
    required this.url,
    required this.title,
    required this.model,
  });

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  bool isLoading = true;
  bool canGoBack = false;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
            _updateCanGoBack();
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            _updateCanGoBack();
          },
          onNavigationRequest: (NavigationRequest request) {
            print('Navigation to: ${request.url}');
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
          },
          onUrlChange: (UrlChange change) {
            print('URL changed to: ${change.url}');
            _updateCanGoBack();
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }
  
  // Update canGoBack state
  Future<void> _updateCanGoBack() async {
    final canGoBack = await controller.canGoBack();
    if (this.canGoBack != canGoBack) {
      setState(() {
        this.canGoBack = canGoBack;
      });
    }
  }

  // Handle back press
  Future<bool> _handleBackPressed() async {
    final canGoBack = await controller.canGoBack();
    if (canGoBack) {
      controller.goBack();
      return false; // Don't pop the WebView screen yet
    } else {
      return true; // Pop the WebView screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (await controller.canGoBack()) {
                controller.goBack();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
} 