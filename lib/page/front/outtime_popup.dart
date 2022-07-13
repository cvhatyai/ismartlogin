import 'package:flutter/material.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/system/clock.dart';
import 'package:ismart_login/system/widht_device.dart';

class OTDialog extends StatefulWidget {
  const OTDialog({Key key, this.onConfirmTap}) : super(key: key);

  @override
  State<OTDialog> createState() => _OTDialogState();
  final GestureTapCallback onConfirmTap;

}

class _OTDialogState extends State<OTDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      content: SingleChildScrollView(
        child: Container(
          width: WidhtDevice().widht(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container(
              //   padding: EdgeInsets.only(top: 5),
              //   height: 150,
              //   child: Image.file(
              //     File(widget.pathImage),
              //     fit: BoxFit.fitHeight,
              //   ),
              // ),
              // Container(
              //   child: Column(
              //     children: [
              //       Text(
              //         Clock().getTime(),
              //         style: TextStyle(
              //           fontFamily: FontStyles().FontFamily,
              //           height: 1,
              //           fontSize: 40,
              //           color: Color(0xFF757575),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // distanc()
              //     ? Container()
              //     : Container(
              //         child: Text(
              //           'คุณไม่ได้อยู่ในพื้นที่',
              //           style: TextStyle(
              //               fontFamily: FontStyles().FontFamily,
              //               fontSize: 18,
              //               color: Colors.red),
              //         ),
              //       ),
              Container(
                height: 100,
                child: Center(
                  child: Text(
                    'คุณกำลังทำงานนอกเวลาใช่หรือไม่',
                    style: TextStyle(
                      fontFamily: FontStyles().FontFamily,
                      height: 1,
                      fontSize: 26,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              // checkTimr(widget.time) ? Container() : _radioButton(),
              // checkTimr(widget.time) ? Container() : _causeNote(),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // Map _map = {
                          //   "uid": widget.uid,
                          //   "time": Clock().onTime(),
                          //   "image": widget.pathImage,
                          //   "latitude": widget.myLat.toString(),
                          //   "longitude": widget.myLng.toString(),
                          //   "start_status": checkTimr(widget.time)
                          //       ? '0'
                          //       : (currentIndex + 1),
                          //   "start_note": _inputNote.text,
                          //   "start_location_status": distanc() ? '0' : '1',
                          //   "log": 'timeid_${widget.timeId}',
                          // };
                          // print("LOGIN : " + _map.toString());
                          // onLoadAttandStart(_map);

                          // ///---
                          // setState(() {});
                          // if (!distanc()) {
                          //   Navigator.pop(context);
                          //   showDialog(
                          //       barrierDismissible: false,
                          //       context: context,
                          //       builder: (_) {
                          //         return OutsideDialog(
                          //             status: 1,
                          //             uid: widget.uid,
                          //             mainLat: widget.lat.toString(),
                          //             mainLng: widget.long.toString(),
                          //             lat: widget.myLat.toString(),
                          //             long: widget.myLng.toString(),
                          //             time: widget.time);
                          //       });
                          // } else {
                          //   Navigator.pop(context);
                          //   EasyLoading.show();
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => MainPage()),
                          //   );
                          //   EasyLoading.dismiss();
                          // }
                        },
                        child: Container(

                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              
                            ),
                          ),
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'ยกเลิก',
                            style: TextStyle(
                                fontFamily: FontStyles().FontFamily,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          widget.onConfirmTap?.call();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.only(
                              
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'ตกลง',
                            style: TextStyle(
                                fontFamily: FontStyles().FontFamily,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}