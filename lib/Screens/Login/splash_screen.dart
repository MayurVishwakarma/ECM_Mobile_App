// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(
                0.5,
                -3.0616171314629196e-17,
              ),
              end: const Alignment(
                0.5,
                0.9999999999999999,
              ),
              colors: [
                Colors.blue.shade100,
                Colors.lightBlue.shade700,
              ],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(
                  0.5,
                  -3.0616171314629196e-17,
                ),
                end: const Alignment(
                  0.5,
                  0.9999999999999999,
                ),
                colors: [
                  Colors.blue.shade100,
                  Colors.lightBlue.shade700,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 99.00,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  /// Company Logo
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 18.00,
                                      right: 18.00,
                                    ),
                                    child: Image.asset(
                                      'assets/images/img_logoresize1.png',
                                      height: 126.00,
                                      width: 186.00,
                                      fit: BoxFit.fill,
                                    ),
                                  ),

                                  ///Image set
                                  Container(
                                    height: 270,
                                    // width: 326.00,
                                    margin: EdgeInsets.only(
                                      left: 18.00,
                                      top: 60.00,
                                      right: 18.00,
                                    ),

                                    ///Polygon Image
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        ///Right
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Image.asset(
                                            'assets/images/img_polygon3.png',
                                            height: 138.00,
                                            width: 138.00,
                                            // fit: BoxFit.fill,
                                          ),
                                        ),

                                        ///Left
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Image.asset(
                                            'assets/images/img_polygon2.png',
                                            height: 138.00,
                                            width: 138.00,
                                            // fit: BoxFit.fill,
                                          ),
                                        ),

                                        ///top
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Image.asset(
                                            'assets/images/img_polygon1.png',
                                            height: 138.00,
                                            width: 138.00,
                                            // fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///App Details
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 18.00,
                                      top: 34.04,
                                      right: 18.00,
                                    ),
                                    child: FittedBox(
                                      child: Text(
                                        "Erection, Commission & Maintenance",
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 18.00,
                                      top: 5.00,
                                      right: 18.00,
                                    ),
                                    child: Text(
                                      "ECM Application",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 18.00,
                                      top: 4.00,
                                      right: 18.00,
                                    ),
                                    child: Text(
                                      "Version 2.7",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        /*Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                0.5,
                -3.0616171314629196e-17,
              ),
              end: Alignment(
                0.5,
                0.9999999999999999,
              ),
              colors: [
                Colors.blue.shade100,
                Colors.lightBlue,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 70.00,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  /// Company Logo
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 18.00,
                                      right: 18.00,
                                    ),
                                    child: Image.asset(
                                      'assets/images/img_logoresize1.png',
                                      height: 126.00,
                                      width: 186.00,
                                      fit: BoxFit.fill,
                                    ),
                                  ),

                                  ///Image set
                                  Container(
                                    height: 300.96,
                                    width: 326.00,
                                    margin: EdgeInsets.only(
                                      // left: 18.00,
                                      top: 47.00,
                                      // right: 16.00,
                                    ),

                                    ///Polygon Image
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        ///Right
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            child: Image.asset(
                                              "assets/images/img_polygon3.png",
                                              height: 138.00,
                                              width: 138.00,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),

                                        ///Left
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10, right: 10),
                                            child: Image.asset(
                                              'assets/images/img_polygon2.png',
                                              height: 138.00,
                                              width: 138.00,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),

                                        ///top
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 20,
                                            ),
                                            child: Image.asset(
                                              'assets/images/img_polygon1.png',
                                              height: 138.00,
                                              width: 138.00,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///App Details
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 18.00,
                                      top: 34.04,
                                      right: 18.00,
                                    ),
                                    child: FittedBox(
                                      child: Text(
                                        "Erection, Commission & Maintenance",
                                        
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 18.00,
                                      top: 5.00,
                                      right: 18.00,
                                    ),
                                    child: Text(
                                      "ECM Application",
                                      
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 18.00,
                                      top: 4.00,
                                      right: 18.00,
                                    ),
                                    child: Text(
                                      "Version 1.6",
                                      
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      */
      ),
    );
  }
}
