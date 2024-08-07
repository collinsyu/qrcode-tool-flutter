import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:qrcode/sqlite/qrcodeGenHistory.dart';
import 'package:vibration/vibration.dart';

import 'components/dyform.dart';
import 'components/headbar.dart';
import 'core/setting.dart';
import 'models/QrCodeItem.dart';

class GenCodeFormPage extends StatefulWidget {
  final String type;
  final int? format;
  GenCodeFormPage({super.key, required this.type,this.format});

  @override
  State<GenCodeFormPage> createState() => _GenCodeFormPageState();
}

class _GenCodeFormPageState extends State<GenCodeFormPage>
    with TickerProviderStateMixin {
  late String type = "text";
  late int format = 256;
  final Map _map = {
    'text': 'Text',
    'url': 'Website',
    'wifi': 'Wi-Fi',
    'email': 'Email',
  };

  @override
  void initState() {
    super.initState();
    type = widget.type;
    format = (widget.format??256) as int;
    switch(type){
      case "text":
        jsonData = [
          {
            "type": "input",
            "field": "Ff1s5zfzgmk0x",
            "title": "Text",
            'hint':"Enter text",
            "hidden": false,
            "display": true
          },
        ];
        break;
      case "url":
        jsonData = [
          {
            "type": "input",
            "field": "Ff1s5zfzgmk0x",
            "title": "Website URL",
            'hint':"www.masteryu.site",
            "hidden": false,
            "display": true
          },
        ];
        break;
      case "wifi":
        jsonData = [
          {
            "type": "input",
            "field": "Ff1s5zfzgmk0x",
            "title": "Network",
            'hint':"Enter network name",
            "hidden": false,
            "display": true
          },
          {
            "type": "input",
            "field": "Ff1s5zfzgmk1x",
            "title": "Password",
            'hint':"Enter password",
            "hidden": false,
            "display": true
          },
        ];
        break;
      case "email":
        jsonData = [
          {
            "type": "input",
            "field": "Ff1s5zfzgmk0x",
            "title": "Email",
            'hint':"Enter email address",
            "hidden": false,
            "display": true
          },
        ];
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
  List<dynamic> jsonData = [];


  void setNewValue(String field, String value, List<dynamic> data) {
    for (var item in data) {
      if (item['field'] == field) {
        item['new_value'] = value;
        return;
      } else if (item.containsKey('children')) {
        setNewValue(field, value, item['children']);
      }
    }
  }

  void textFormFieldChanged(Map item, String value) {
    setNewValue(item["field"], value, jsonData);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xcc333333),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                CommonHeadBar(
                  title: _map[type].toString(),
                ),
                Expanded(
                  child: Container(
                    // color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: EdgeInsets.all(32.0),
                          decoration: BoxDecoration(
                            color: Color(0xffFDB623),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xff333333),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            padding: EdgeInsets.all(16.0),
                            margin: EdgeInsets.symmetric(vertical: 2.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 8.0,
                                ),

                                RenderTypeImage(type),
                                SizedBox(
                                  height: 32.0,
                                ),

                                //   表单

                                DynamicForm(
                                  schemaData: jsonData,
                                  textFormFieldChanged: textFormFieldChanged,

                                ),
                                SizedBox(
                                  height: 32.0,
                                ),
                                Text(format.toString()),
                                CupertinoButton(
                                  onPressed: () async {
                                    print(jsonData);
                                    String value = "";
                                    if(SettingConfig.ISVIBRATE){
                                      await Vibration.vibrate(duration: 50); // 500毫秒

                                    }
                                    switch(type){
                                      case "text":
                                        value = jsonData[0]["new_value"];
                                      case "url":
                                        value = jsonData[0]["new_value"];
                                      case "email":
                                        value = jsonData[0]["new_value"];
                                      case "wifi":
                                        value = 'WIFI:${jsonData[1]["new_value"]};${jsonData[0]["new_value"]}';
                                    }
                                    // 这里不考虑那个 wifi那个哈哈哈哈
                                    if(value == ''){
                                      return;
                                    }




                                    DateTime now = DateTime.now();

                                    DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
                                    String formattedDate = formatter.format(now);

                                    var example = QrCodeItem(
                                      // id: 0,
                                        value: value,
                                        type: "text",
                                        format:format,
                                        date: formattedDate
                                    );
                                    print(example);
                                    int? newId = await QrcodeGenHistory.insertQrcode(example);
                                    Navigator.pushNamed(context, '/detail_gen',arguments: newId);

                                  },
                                  color: Color(0xffFDB623),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: const Text('Generate QR Code',
                                      style: TextStyle(
                                          color: Color(0xff333333),
                                          fontSize: 16)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ])),
    );
  }
}

class RenderTypeImage extends StatelessWidget {
  // RenderTypeImage(String type, {super.key});
  RenderTypeImage(this.type, {Key? key}) : super(key: key);

  final type;
  final Map _map = {
    'text': 'icon-msgtype-text.png',
    'url': 'icon-msgtype-url.png',
    'wifi': 'icon-msgtype-wifi.png',
    'email': 'icon-msgtype-email.png',
  };

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      // color: Color(0xffd9d9d9),
      'images/' + _map[type],
      width: 60.0, // 设置图片的宽度
// height: 25.0, // 设置图片的高度
      fit: BoxFit.fitWidth, // 图片填充方式
    );
  }
}
