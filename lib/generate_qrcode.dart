import 'package:flutter/material.dart';

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
                    Container(
                      padding: EdgeInsets.only(top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Generate QR",style: TextStyle(
                              color: Color(0xFFD9D9D9),
                              fontSize: 24.0
                          ),),
                          IconButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/setting');

                            },
                            icon: Container(
                              decoration: BoxDecoration(
                                color:  Color(0xcc333333),

                                borderRadius: BorderRadius.all(Radius.circular(10.0)), // 设置所有角的圆角半径为10.0
                              ),
                              padding: const EdgeInsets.all(8.0),

                              child: Image.asset('images/icon-setting-inner.png',
                                width: 24.0, // 设置图片的宽度
                                height: 24.0, // 设置图片的高度
                                fit: BoxFit.cover, // 图片填充方式
                              ),
                            ),
                          )

                        ],
                      ),
                    ),

                  //   grid

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
                          IconButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/genform',arguments: "text");

                            },
                            padding: EdgeInsets.all(0.0),
                            icon:  Image.asset('images/icon-scantype-text.png',
                              fit: BoxFit.fitHeight, // 图片填充方式
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/genform',arguments: "url");

                            },
                            padding: EdgeInsets.all(0.0),
                            icon:  Image.asset('images/icon-scantype-url.png',
                              fit: BoxFit.fitHeight, // 图片填充方式
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/genform',arguments: "email");

                            },
                            padding: EdgeInsets.all(0.0),
                            icon:  Image.asset('images/icon-scantype-email.png',
                              fit: BoxFit.fitHeight, // 图片填充方式
                            ),
                          ),
                          IconButton(
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
                          IconButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/genform',arguments: "wifi");

                            },
                            padding: EdgeInsets.all(0.0),
                            icon:  Image.asset('images/icon-scantype-wifi.png',
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
