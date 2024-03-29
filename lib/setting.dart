import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vibration/vibration.dart';
import '../core/setting.dart';
import 'components/headbar.dart';
import 'package:flutter_beep/flutter_beep.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with TickerProviderStateMixin {
  bool isVibrate = true;
  bool isBeep = true;

  @override
  void initState() {
    super.initState();

    isVibrate = SettingConfig.ISVIBRATE;
    isBeep = SettingConfig.ISBEEP;


  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xcc333333),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  CommonHeadBar(title: ''),

                  SizedBox(height: 20.0,),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Settings",style: TextStyle(
                        color: Color(0xffFDB623),
                        fontSize: 26
                    ),),
                  ),

                  // 是否震动
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 4.0),
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
                      margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,2.0),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon-vibrate.png',
                            width: 21.0, // 设置图片的宽度
                            height: 21.0, // 设置图片的高度
                            fit: BoxFit.fitHeight, // 图片填充方式
                          ),
                          SizedBox(width: 16.0,),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Vibrate",style: TextStyle(color: Color(0xffE2E2E2),fontSize: 16),),
                                    Text("Vibration when scan is done.",style: TextStyle(
                                        color: Color(0xffC3C7C7),
                                        fontSize: 14
                                    ),)
                                  ],
                                ),



                                Transform.scale(
                                  scale: .6,
                                  child: Switch(
                                      value: isVibrate,
                                      activeTrackColor: Color(0xaaFDB623),
                                      activeColor: Color(0xffFDB623),

                                      inactiveTrackColor: Color(0x33FFFFFF),
                                      inactiveThumbColor: Color(0xff979797),
                                      materialTapTargetSize: MaterialTapTargetSize.padded,
                                      trackOutlineWidth: MaterialStateProperty.resolveWith<double?>((Set<MaterialState> states) {

                                         return 0; // Use the default width.
                                       }),

                                      onChanged: (bool _isvibrate) async {
                                        if(_isvibrate){
                                          await Vibration.vibrate(duration: 50); // 500毫秒

                                        }
                                        setState(() {
                                          isVibrate = _isvibrate;
                                          SettingConfig.ISVIBRATE = _isvibrate;
                                        });
                                                              
                                  }),
                                )
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
  // 是否扫描beep！！！
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 4.0),
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
                      margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,2.0),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon-beep.png',
                            width: 21.0, // 设置图片的宽度
                            height: 21.0, // 设置图片的高度
                            fit: BoxFit.fitHeight, // 图片填充方式
                          ),
                          SizedBox(width: 16.0,),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Beep",style: TextStyle(color: Color(0xffE2E2E2),fontSize: 16),),
                                    Text("Beep when scan is done.",style: TextStyle(
                                        color: Color(0xffC3C7C7),
                                        fontSize: 14
                                    ),)
                                  ],
                                ),



                                Transform.scale(
                                  scale: .6,
                                  child: Switch(
                                      value: isBeep,
                                      activeTrackColor: Color(0xaaFDB623),
                                      activeColor: Color(0xffFDB623),

                                      inactiveTrackColor: Color(0x33FFFFFF),
                                      inactiveThumbColor: Color(0xff979797),
                                      materialTapTargetSize: MaterialTapTargetSize.padded,
                                      trackOutlineWidth: MaterialStateProperty.resolveWith<double?>((Set<MaterialState> states) {

                                        return 0; // Use the default width.
                                      }),

                                      onChanged: (bool _bool) async {
                                        if(_bool){
                                          // FlutterBeep.beep(); // 播放一次提示音
                                          FlutterBeep.playSysSound(25);

                                        }
                                        setState(() {
                                          isBeep = _bool;
                                          SettingConfig.ISBEEP = _bool;
                                        });

                                      }),
                                )
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40.0,),
                  // ===============================================
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Apply for a job!!",style: TextStyle(
                      color: Color(0xffFDB623),
                      fontSize: 26
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 4.0),
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
                      margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,2.0),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon-reward.png',
                            width: 21.0, // 设置图片的宽度
                            height: 21.0, // 设置图片的高度
                            fit: BoxFit.fitHeight, // 图片填充方式
                          ),
                          SizedBox(width: 16.0,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Contact Me",style: TextStyle(color: Color(0xffE2E2E2),fontSize: 16),),
                              Text("yuhaiqing124@163.com",style: TextStyle(
                                  color: Color(0xffC3C7C7),
                                  fontSize: 14
                              ),)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 4.0),
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
                      margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,2.0),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon-setting-alert.png',
                            width: 24.0, // 设置图片的宽度
                            height: 24.0, // 设置图片的高度
                            fit: BoxFit.fitHeight, // 图片填充方式
                          ),
                          SizedBox(width: 16.0,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Resume",style: TextStyle(color: Color(0xffE2E2E2),fontSize: 16),),
                              Text("http://resume.masteryu.site/",style: TextStyle(
                                  color: Color(0xffC3C7C7),
                                  fontSize: 14
                              ),)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 4.0),
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
                      margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,2.0),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon-setting-share.png',
                            width: 24.0, // 设置图片的宽度
                            height: 24.0, // 设置图片的高度
                            fit: BoxFit.fitHeight, // 图片填充方式
                          ),
                          SizedBox(width: 16.0,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Phone / Wechat",style: TextStyle(color: Color(0xffE2E2E2),fontSize: 16),),
                              Text("17354701042",style: TextStyle(
                                  color: Color(0xffC3C7C7),
                                  fontSize: 14
                              ),)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ])),

    );
  }
}
