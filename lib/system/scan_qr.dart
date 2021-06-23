import 'package:flutter/material.dart';
// import 'package:flutter_qrcode_scanner/flutter_qrcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ismart_login/style/page_style.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class ScanQrcode extends StatefulWidget {
  @override
  _ScanQrcodeState createState() => _ScanQrcodeState();
}

class _ScanQrcodeState extends State<ScanQrcode> {
  var qrText = '';
  var flashState = flashOn;
  var cameraState = frontCamera;
  // QRViewController controller;
  //---
  //Setup
  PickedFile _imageFile;
  dynamic _pickImageError;
  //----
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: StylePage().background,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Stack(
                children: [
                  // QRView(
                  //   key: qrKey,
                  //   onQRViewCreated: _onQRViewCreated,
                  //   overlay: QrScannerOverlayShape(
                  //     borderColor: Colors.blue,
                  //     borderRadius: 20,
                  //     borderLength: 40,
                  //     borderWidth: 20,
                  //     cutOutSize: 300,
                  //   ),
                  // ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Row(
                      children: [
                        ClipOval(
                          child: Material(
                            color:
                                Colors.black.withOpacity(0.5), // button color
                            child: GestureDetector(
                              child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  )),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   bottom: 10,
                  //   left: 10,
                  //   child: Row(
                  //     children: [
                  //       ClipOval(
                  //         child: Material(
                  //           color:
                  //               Colors.black.withOpacity(0.5), // button color
                  //           child: GestureDetector(
                  //             child: SizedBox(
                  //                 width: 56,
                  //                 height: 56,
                  //                 child: Icon(
                  //                   Icons.image,
                  //                   color: Colors.white,
                  //                 )),
                  //             onTap: () {
                  //               _imgFromGallery();
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Positioned(
                    bottom: 10,
                    right: 80,
                    child: Row(
                      children: [
                        ClipOval(
                          child: Material(
                            color:
                                Colors.black.withOpacity(0.5), // button color
                            child: GestureDetector(
                              child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: Icon(
                                    flashState == 'FLASH ON'
                                        ? Icons.flash_on
                                        : Icons.flash_off,
                                    color: Colors.white,
                                  )),
                              onTap: () {
                                // if (controller != null) {
                                //   controller.toggleFlash();
                                //   if (_isFlashOn(flashState)) {
                                //     setState(() {
                                //       flashState = flashOff;
                                //     });
                                //   } else {
                                //     setState(() {
                                //       flashState = flashOn;
                                //     });
                                //   }
                                // }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Row(
                      children: [
                        ClipOval(
                          child: Material(
                            color:
                                Colors.black.withOpacity(0.5), // button color
                            child: GestureDetector(
                              child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: Icon(
                                    cameraState == 'FRONT CAMERA'
                                        ? Icons.camera_front
                                        : Icons.camera_rear,
                                    color: Colors.white,
                                  )),
                              onTap: () {
                                // if (controller != null) {
                                //   controller.flipCamera();
                                //   if (_isBackCamera(cameraState)) {
                                //     setState(() {
                                //       cameraState = frontCamera;
                                //     });
                                //   } else {
                                //     setState(() {
                                //       cameraState = backCamera;
                                //     });
                                //   }
                                // }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((scanData) {
  //     Navigator.pop(context, scanData.toString());
  //     // setState(() {
  //     //   qrText = scanData;
  //     //   if (qrText != '') {
  //     //     Future.delayed(Duration.zero, () {
  //     //       Navigator.pop(context, qrText.toString());
  //     //     });
  //     //   }
  //     // });
  //   });
  // }

  // void _imgFromGallery() async {
  //   try {
  //     final pickedFile = await ImagePicker().getImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 50,
  //     );
  //     setState(() async {
  //       _imageFile = pickedFile;
  //       final rest = await FlutterQrReader.imgScan(_imageFile.path);
  //       Navigator.pop(context, rest.toString());
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _pickImageError = e;
  //       print(_pickImageError.toString());
  //     });
  //   }
  // }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }
}
