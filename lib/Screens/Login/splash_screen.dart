// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ecm_application/core/app_export.dart';

class SplashScreen extends StatelessWidget {
  void initState() {
    //super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              gradient: ColorConstant
                  .appBarGradient /*LinearGradient(
              begin: Alignment(
                0.5,
                -3.0616171314629196e-17,
              ),
              end: Alignment(
                0.5,
                0.9999999999999999,
              ),
              colors: [
                ColorConstant.blue100,
                ColorConstant.lightBlue700,
              ],
            ),*/
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
                              top: getVerticalSize(
                                99.00,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                /// Company Logo
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: getHorizontalSize(
                                      18.00,
                                    ),
                                    right: getHorizontalSize(
                                      18.00,
                                    ),
                                  ),
                                  child: Image.asset(
                                    ImageConstant.imgLogoresize1,
                                    height: getVerticalSize(
                                      126.00,
                                    ),
                                    width: getHorizontalSize(
                                      186.00,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),

                                ///Image set
                                Container(
                                  height: getVerticalSize(
                                    243.96,
                                  ),
                                  width: getHorizontalSize(
                                    326.00,
                                  ),
                                  margin: EdgeInsets.only(
                                    left: getHorizontalSize(
                                      18.00,
                                    ),
                                    top: getVerticalSize(
                                      47.00,
                                    ),
                                    right: getHorizontalSize(
                                      16.00,
                                    ),
                                  ),

                                  ///Polygon Image
                                  child: Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: [
                                      ///Right
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: getHorizontalSize(
                                              10.00,
                                            ),
                                            top: getVerticalSize(
                                              10.00,
                                            ),
                                            bottom: getVerticalSize(
                                              0.00,
                                            ),
                                          ),
                                          child: Image.asset(
                                            ImageConstant.imgPolygon3,
                                            height: getSize(
                                              138.00,
                                            ),
                                            width: getSize(
                                              138.00,
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),

                                      ///Left
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: getVerticalSize(
                                              10.00,
                                            ),
                                            right: getHorizontalSize(
                                              10.00,
                                            ),
                                            bottom: getVerticalSize(
                                              1.00,
                                            ),
                                          ),
                                          child: Image.asset(
                                            ImageConstant.imgPolygon2,
                                            height: getVerticalSize(
                                              120.00,
                                            ),
                                            width: getHorizontalSize(
                                              138.00,
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),

                                      ///top
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: getHorizontalSize(
                                              91.39,
                                            ),
                                            right: getHorizontalSize(
                                              91.39,
                                            ),
                                            bottom: getVerticalSize(
                                              10.00,
                                            ),
                                          ),
                                          child: Image.asset(
                                            ImageConstant.imgPolygon1,
                                            height: getSize(
                                              138.00,
                                            ),
                                            width: getSize(
                                              138.00,
                                            ),
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
                                    left: getHorizontalSize(
                                      18.00,
                                    ),
                                    top: getVerticalSize(
                                      34.04,
                                    ),
                                    right: getHorizontalSize(
                                      18.00,
                                    ),
                                  ),
                                  child: FittedBox(
                                    child: Text(
                                      "Erection, Commission & Maintenance",
                                      textScaleFactor: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorConstant.whiteA700,
                                        fontSize: getFontSize(
                                          22,
                                        ),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: getHorizontalSize(
                                      18.00,
                                    ),
                                    top: getVerticalSize(
                                      5.00,
                                    ),
                                    right: getHorizontalSize(
                                      18.00,
                                    ),
                                  ),
                                  child: Text(
                                    "ECM Application",
                                    textScaleFactor: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: ColorConstant.whiteA700,
                                      fontSize: getFontSize(
                                        18,
                                      ),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: getHorizontalSize(
                                      18.00,
                                    ),
                                    top: getVerticalSize(
                                      4.00,
                                    ),
                                    right: getHorizontalSize(
                                      18.00,
                                    ),
                                  ),
                                  child: Text(
                                    "Version 0.6",
                                    textScaleFactor: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: ColorConstant.black900,
                                      fontSize: getFontSize(
                                        12,
                                      ),
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
    );
  }
}
