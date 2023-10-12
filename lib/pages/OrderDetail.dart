import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_1/utils.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 411;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: double.infinity,
      child: Container(
        // wologiniab (1:1010)
        padding: EdgeInsets.fromLTRB(27 * fem, 27 * fem, 31 * fem, 38 * fem),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xfff3f4f6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // systembar1pb (1:1011)
              margin: EdgeInsets.fromLTRB(8 * fem, 0 * fem, 5 * fem, 89 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // ellipse1XY3 (1:1013)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 13 * fem, 0 * fem),
                    width: 4 * fem,
                    height: 4 * fem,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2 * fem),
                      color: Color(0x7f000000),
                    ),
                  ),
                  Container(
                    // SQ7 (1:1012)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 1 * fem, 237 * fem, 0 * fem),
                    child: Text(
                      '12:00',
                      style: SafeGoogleFont(
                        'Roboto',
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w500,
                        height: 1.1725 * ffem / fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Container(
                    // vector1LkP (1:1015)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 6 * fem, 4 * fem),
                    width: 14 * fem,
                    height: 14 * fem,
                    child: Image.asset(
                      'assets/images/vector-1-tsq.png',
                      width: 14 * fem,
                      height: 14 * fem,
                    ),
                  ),
                  Container(
                    // ellipse2G8F (1:1014)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 5 * fem, 3 * fem),
                    width: 17 * fem,
                    height: 13 * fem,
                    child: Image.asset(
                      'assets/page-1/images/ellipse-2-SnK.png',
                      width: 17 * fem,
                      height: 13 * fem,
                    ),
                  ),
                  Container(
                    // unionz4F (1:1016)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 3 * fem),
                    width: 8 * fem,
                    height: 13 * fem,
                    child: Image.asset(
                      'assets/page-1/images/union-Gnb.png',
                      width: 8 * fem,
                      height: 13 * fem,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // group35tvK (1:1055)
              margin:
                  EdgeInsets.fromLTRB(0 * fem, 0 * fem, 285 * fem, 32.21 * fem),
              width: 68 * fem,
              height: 75.79 * fem,
              child: Image.asset(
                'assets/page-1/images/group-35-aoH.png',
                width: 68 * fem,
                height: 75.79 * fem,
              ),
            ),
            Container(
              // welcomeCAK (1:1069)
              margin:
                  EdgeInsets.fromLTRB(0 * fem, 0 * fem, 248 * fem, 30 * fem),
              child: Text(
                'WELCOME',
                style: SafeGoogleFont(
                  'Nunito',
                  fontSize: 20 * ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.3625 * ffem / fem,
                  color: Color(0xff374151),
                ),
              ),
            ),
            Container(
              // autogroup5vbdWB1 (RKCys9VjsoCvMthBN45VBd)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 28 * fem),
              width: double.infinity,
              height: 64 * fem,
              child: Stack(
                children: [
                  Positioned(
                    // fieldpSb (1:1019)
                    left: 0 * fem,
                    top: 8 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 353 * fem,
                        height: 56 * fem,
                        child: Image.asset(
                          'assets/page-1/images/field-nSs.png',
                          width: 353 * fem,
                          height: 56 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // embeddedlabel7wV (1:1031)
                    left: 0 * fem,
                    top: 0 * fem,
                    child: Container(
                      width: 339 * fem,
                      height: 16 * fem,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // labeleRd (1:1032)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 4 * fem, 0 * fem),
                            padding: EdgeInsets.fromLTRB(
                                16 * fem, 0 * fem, 0 * fem, 0 * fem),
                            height: double.infinity,
                            child: Text(
                              'Email',
                              style: SafeGoogleFont(
                                'Nunito',
                                fontSize: 12 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.3333333333 * ffem / fem,
                                letterSpacing: 0.400000006 * fem,
                                color: Color(0xff374151),
                              ),
                            ),
                          ),
                          Container(
                            // strokeclippingWTq (1:1036)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 8 * fem, 0 * fem, 0 * fem),
                            width: 296 * fem,
                            child: Center(
                              // strokeepw (1:1037)
                              child: SizedBox(
                                width: double.infinity,
                                height: 8 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffd1d5db)),
                                  ),
                                ),
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
            Container(
              // autogroupa8kpPXd (RKCz7URCgj2LQuHJ9eA8kP)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 43 * fem),
              width: double.infinity,
              height: 64 * fem,
              child: Stack(
                children: [
                  Positioned(
                    // fieldXNw (1:1038)
                    left: 0 * fem,
                    top: 8 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 353 * fem,
                        height: 56 * fem,
                        child: Image.asset(
                          'assets/page-1/images/field-gmd.png',
                          width: 353 * fem,
                          height: 56 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // embeddedlabelpsq (1:1048)
                    left: 0 * fem,
                    top: 0 * fem,
                    child: Container(
                      width: 339 * fem,
                      height: 16 * fem,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // labelMcs (1:1049)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 3 * fem, 0 * fem),
                            padding: EdgeInsets.fromLTRB(
                                16 * fem, 0 * fem, 0 * fem, 0 * fem),
                            height: double.infinity,
                            child: Text(
                              'Password',
                              style: SafeGoogleFont(
                                'Nunito',
                                fontSize: 12 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.3333333333 * ffem / fem,
                                letterSpacing: 0.400000006 * fem,
                                color: Color(0xff374151),
                              ),
                            ),
                          ),
                          Container(
                            // strokeclippingqnw (1:1053)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 8 * fem, 0 * fem, 0 * fem),
                            width: 296 * fem,
                            child: Center(
                              // strokezQw (1:1054)
                              child: SizedBox(
                                width: double.infinity,
                                height: 8 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffd1d5db)),
                                  ),
                                ),
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
            Container(
              // component5XQs (1:1065)
              margin: EdgeInsets.fromLTRB(3 * fem, 0 * fem, 0 * fem, 39 * fem),
              width: 350 * fem,
              height: 51 * fem,
              decoration: BoxDecoration(
                color: Color(0xff1d4ed8),
                borderRadius: BorderRadius.circular(8 * fem),
              ),
              child: Center(
                child: Text(
                  'LOG rrIN',
                  textAlign: TextAlign.center,
                  style: SafeGoogleFont(
                    'Open Sans',
                    fontSize: 16 * ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.3625 * ffem / fem,
                    letterSpacing: 1.6 * fem,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ),
            Container(
              // forregistrationorpasswordrecov (1:1070)
              margin: EdgeInsets.fromLTRB(3 * fem, 0 * fem, 0 * fem, 175 * fem),
              constraints: BoxConstraints(
                maxWidth: 271 * fem,
              ),
              child: Text(
                'For registration or password recovery, contact us: 587 4574',
                textAlign: TextAlign.center,
                style: SafeGoogleFont(
                  'Nunito',
                  fontSize: 16 * ffem,
                  fontWeight: FontWeight.w400,
                  height: 1.3625 * ffem / fem,
                  color: Color(0xff374151),
                ),
              ),
            ),
            Container(
              // group31SAT (1:1066)
              margin: EdgeInsets.fromLTRB(85 * fem, 0 * fem, 86 * fem, 0 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // version100ZVy (1:1067)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 12 * fem, 0 * fem),
                    child: RichText(
                      text: TextSpan(
                        style: SafeGoogleFont(
                          'Montserrat',
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w700,
                          height: 1.2189999989 * ffem / fem,
                          color: Color(0xff9ca3af),
                        ),
                        children: [
                          TextSpan(
                            text: 'Version: ',
                            style: SafeGoogleFont(
                              'Nunito',
                              fontSize: 14 * ffem,
                              fontWeight: FontWeight.w500,
                              height: 1.3625 * ffem / fem,
                              color: Color(0xff9ca3af),
                            ),
                          ),
                          TextSpan(
                            text: '1.0.0',
                            style: SafeGoogleFont(
                              'Nunito',
                              fontSize: 14 * ffem,
                              fontWeight: FontWeight.w500,
                              height: 1.3625 * ffem / fem,
                              color: Color(0xff9ca3af),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  RichText(
                    // august2023C55 (1:1068)
                    text: TextSpan(
                      style: SafeGoogleFont(
                        'Montserrat',
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.2189999989 * ffem / fem,
                        color: Color(0xff9ca3af),
                      ),
                      children: [
                        TextSpan(
                          text: 'August ',
                          style: SafeGoogleFont(
                            'Nunito',
                            fontSize: 14 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.3625 * ffem / fem,
                            color: Color(0xff9ca3af),
                          ),
                        ),
                        TextSpan(
                          text: '2023',
                          style: SafeGoogleFont(
                            'Nunito',
                            fontSize: 14 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.3625 * ffem / fem,
                            color: Color(0xff9ca3af),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
