import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ismart_login/page/sign/signin_screen.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/style/page_style.dart';
import 'package:ismart_login/system/widht_device.dart';
import 'package:r_scan/r_scan.dart';

import '../main.dart';

class RScanCameraDialog extends StatefulWidget {
  @override
  _RScanCameraDialogState createState() => _RScanCameraDialogState();
}

class _RScanCameraDialogState extends State<RScanCameraDialog> {
  RScanCameraController _controller;
  bool isFirst = true;

  @override
  void initState() {
    // print(len);
    super.initState();
    if (rScanCameras != null && rScanCameras.length > 0) {
      _controller = RScanCameraController(
        rScanCameras[0],
        RScanCameraResolutionPreset.max,
      )
        ..addListener(() {
          final result = _controller.result;
          if (result != null) {
            if (isFirst) {
              Navigator.of(context).pop(result.message);
              print("reader ===========> " + result.message);
              isFirst = false;
            }
          }
        })
        ..initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (rScanCameras == null || rScanCameras.length == 0) {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Text('not have available camera'),
        ),
      );
    }
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: StylePage().background,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'สแกนคิวอาร์โค๊ด',
                          style: TextStyle(
                              fontFamily: FontStyles().FontFamily,
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: FaIcon(
                            FontAwesomeIcons.times,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
                    width: WidhtDevice().widht(context),
                    decoration: StylePage().boxWhite,
                    child: Column(
                      children: [
                        Stack(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: RScanCamera(_controller),
                            ),
                            // Positioned(
                            //   bottom: 0,
                            //   child: Align(
                            //     alignment: Alignment.bottomCenter,
                            //     child: FutureBuilder(
                            //       future: getFlashMode(),
                            //       builder: _buildFlashBtn,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FutureBuilder(
                            future: getFlashMode(),
                            builder: _buildFlashBtn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> getFlashMode() async {
    bool isOpen = false;
    try {
      isOpen = await _controller.getFlashMode();
    } catch (_) {}
    return isOpen;
  }

  Widget _buildFlashBtn(BuildContext context, AsyncSnapshot<bool> snapshot) {
    return snapshot.hasData
        ? Padding(
            padding: EdgeInsets.only(
                bottom: 24 + MediaQuery.of(context).padding.bottom),
            child: IconButton(
                icon: Icon(snapshot.data ? Icons.flash_on : Icons.flash_off),
                color: Colors.black,
                iconSize: 46,
                onPressed: () {
                  if (snapshot.data) {
                    _controller.setFlashMode(false);
                  } else {
                    _controller.setFlashMode(true);
                  }

                  setState(() {});
                }),
          )
        : Container();
  }
}
