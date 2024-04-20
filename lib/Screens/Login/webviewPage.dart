import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web View"),
      ),
      body: const Column(
        children: [
          Text("Web View"),
          SizedBox(
            height: 500,
            width: double.infinity,
            child: WebView(
              initialUrl:
                  'https://app.vectary.com/p/01scLRK3eakksws74ilFnc', // Replace with your desired URL
              javascriptMode: JavascriptMode.unrestricted,
            ),
          )
        ],
      ),
    );
  }
}
