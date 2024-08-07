import 'package:flutter/material.dart';

import 'components/i_custom_button.dart';
import 'components/mainheadbar.dart';

class GenerateQrcode extends StatefulWidget {
  const GenerateQrcode({super.key});

  @override
  State<GenerateQrcode> createState() => _GenerateQrcodeState();
}

class _GenerateQrcodeState extends State<GenerateQrcode> with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List iconlist = [
    SizedBox(
      child: Image.asset('images/icon-setting-inner.png',
        width: 24.0, // 设置图片的宽度
        height: 24.0, // 设置图片的高度
        fit: BoxFit.cover, // 图片填充方式
      ),
    )
  ];


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Color(0xcc333333),
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height:  MediaQuery.of(context).padding.top),

                Padding(padding:EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 0),child: Column(
                  children: [
                    MainCommonHeadBar(title:"Generate"),
                  //   grid
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Qrcode",style: TextStyle(
                            color: Color(0xffFDB623),
                              fontSize: 20.0

                          ),)
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 16.0),
                      height: 2.0,
                      color:Color(0xffFDB623),
                    ),
                    Container(
                      height: 260,
                      child: GridView(
                        padding: EdgeInsets.symmetric(vertical: 32.0,horizontal: 16.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing:40,
                            crossAxisSpacing:40,
                            childAspectRatio:1,
                        ),
                        children: [
                          ICustomButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/genform',arguments: {
                                'type':"text"
                              });

                            },
                            padding: EdgeInsets.all(0.0),
                            icon:  Image.asset('images/icon-scantype-text.png',
                              fit: BoxFit.fitHeight, // 图片填充方式
                            ),
                          ),
                          ICustomButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/genform',arguments: {
                                'type':"url"
                              });

                            },
                            padding: EdgeInsets.all(0.0),
                            icon:  Image.asset('images/icon-scantype-url.png',
                              fit: BoxFit.fitHeight, // 图片填充方式
                            ),
                          ),
                          ICustomButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/genform',arguments: {
                                'type':"email"
                              });

                            },
                            padding: EdgeInsets.all(0.0),
                            icon:  Image.asset('images/icon-scantype-email.png',
                              fit: BoxFit.fitHeight, // 图片填充方式
                            ),
                          ),
                          ICustomButton(
                            onPressed: (){
                              // Navigator.pushNamed(context, '/genform',arguments: "event");
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                  const SnackBar(
                                    content: Text('等我有时间开发，or，欢迎你commit new feat'),
                                    backgroundColor: Colors.blue,
                                  )
                              );
                            },
                            padding: EdgeInsets.all(0.0),
                            icon:  Image.asset('images/icon-scantype-event.png',
                              fit: BoxFit.fitHeight, // 图片填充方式
                            ),
                          ),
                          ICustomButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/genform',arguments: {
                                'type':"wifi"
                              });

                            },
                            padding: EdgeInsets.all(0.0),
                            icon:  Image.asset('images/icon-scantype-wifi.png',
                              fit: BoxFit.fitHeight, // 图片填充方式
                            ),
                          ),


                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("BarCode",style: TextStyle(
                              color: Color(0xffFDB623),
                              fontSize: 20.0

                          ),)
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 16.0),
                      height: 2.0,
                      color:Color(0xffFDB623),
                    ),
                    Container(
                      height: 300,
                      child: GridView(
                        padding: EdgeInsets.symmetric(vertical: 32.0,horizontal: 16.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing:40,
                          crossAxisSpacing:40,
                          childAspectRatio:1,
                        ),
                        children: [
                          ICustomButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/genform',arguments:{
                                'type': "text",'format':1
                              });

                            },
                            padding: EdgeInsets.all(0.0),
                            icon:  Image.asset('images/icon-scantype-text.png',
                              fit: BoxFit.fitHeight, // 图片填充方式
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),),



              ],
            ),
        ),
      );

  }
}
