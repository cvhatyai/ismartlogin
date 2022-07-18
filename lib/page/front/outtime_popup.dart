import 'package:flutter/material.dart';
import 'package:ismart_login/style/font_style.dart';
import 'package:ismart_login/system/clock.dart';
import 'package:ismart_login/system/widht_device.dart';

class OTDialog extends StatefulWidget {
  const OTDialog({Key key, this.onConfirmTap}) : super(key: key);

  @override
  State<OTDialog> createState() => _OTDialogState();
  final Function(String) onConfirmTap;
  
}

class _OTDialogState extends State<OTDialog> {
  TextEditingController _inputNote = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(
                            'หมายเหตุ',
                            style: TextStyle(
                                fontFamily: FontStyles().FontFamily,
                                fontSize: 22),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _inputNote,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontFamily: FontStyles().FontFamily,
                                  fontSize: 22),
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(
                                      0), // add padding to adjust icon
                                  child: Icon(
                                    Icons.edit,
                                    size: 22,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                print("value $value");
                                if (value == null || value.isEmpty) {
                                  return 'กรุณาป้อนข้อมูล';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
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
                          if (_formKey.currentState.validate()) {
widget.onConfirmTap?.call(_inputNote.text);
                          }
                
                          
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

  _causeNote() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            'สาเหตุ',
            style: TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 22),
          ),
          Expanded(
            child: TextFormField(
              controller: _inputNote,
              keyboardType: TextInputType.text,
              style:
                  TextStyle(fontFamily: FontStyles().FontFamily, fontSize: 22),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(0), // add padding to adjust icon
                  child: Icon(
                    Icons.edit,
                    size: 22,
                  ),
                ),
              ),
              validator: (value) {
                print("valueOT $value");
                if (value == null || value.isEmpty) {
                  return 'กรุณาป้อนข้อมูล';
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }
}
