import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  final String postUrl;
  const RecipeView({super.key, required this.postUrl});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late String finalUrl;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    if (widget.postUrl.contains("http://")) {
    } else {
      finalUrl = widget.postUrl.replaceAll("http://", "https://");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  top: 50, right: 40, left: 40, bottom: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff213A50),
                    Color(0xff071930),
                  ],
                ),
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment:
                    kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "VT",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Recipe",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width,
              child: WebView(
                initialUrl: finalUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  setState(() {
                    _controller.complete(webViewController);
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
