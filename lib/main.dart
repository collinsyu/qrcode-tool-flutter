import 'package:flutter/material.dart';

import 'package:qrcode/sqlite/init.dart';

import './scan_page.dart';
import './generate_qrcode.dart';
import './scan_history.dart';
import "./scan_detail.dart";
import './setting.dart';
import './genqrcodeformpage.dart';
import 'components/i_custom_button.dart';
import 'gen_detail.dart';




// 路由，
final routes = {
  '/detail': (context, {arguments}) => ScanDetail(id: arguments),
  '/detail_gen': (context, {arguments}) => GenDetail(id: arguments),
  '/setting': (context, {arguments}) =>  SettingPage(),
  '/genform': (context, {arguments}) =>  GenCodeFormPage(type:arguments),
  '/': (context, {arguments}) => MyHome(),
};


var onGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name;
  final Function pageContentBuilder = routes[name] as Function;
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
        builder: (context) => pageContentBuilder(context, arguments: settings.arguments),
      );
      return route;
    } else {
      final Route route = MaterialPageRoute(
        builder: (context) => pageContentBuilder(context),
      );
      return route;
    }
  }
  return null;
};

void main() => runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    onGenerateRoute: onGenerateRoute,
    initialRoute: '/',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      useMaterial3: true,
    ),
    home: MyHome()
  )

);



class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: MainContainer()
      ),
    );
  }
}



class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int tabIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabIndex = 1;
    _initDatabase();

  }
  void _handleSwitchTab(int s){
    print("跳转到页面"+s.toString());
    setState(() {
      tabIndex = s;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Visibility(
                    visible: tabIndex == 0,
                    maintainState: true,
                    child: GenerateQrcode(),
                  ),
                  Visibility(
                    visible: tabIndex == 1,
                    child: BarcodeScannerWithOverlay() ,
                  ),

                  Visibility(
                    visible: tabIndex == 2,
                    maintainState: false,
                    child: ScanHistory(),
                  ),

                  // widgets[tabIndex],

                  // 底部menu
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0, // 设置Container的高度为100
                    height: 136,
                    child:  Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0,horizontal: 48.0),
                        child: Container(

                          decoration: BoxDecoration(
                            color:  Color(0xcc333333),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)), // 设置所有角的圆角半径为10.0
                          ),
                          // height: 100.0,
                          child: Align(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [

                                    Column(
                                      children: [
                                        ICustomButton(
                                            onPressed: () {_handleSwitchTab(0);},

                                          icon: Image.asset(
                                            'images/icon-qrcode.png',
                                            color: tabIndex == 0? Color(0xffFDB623): Color(0xffd9d9d9),

                                            width: 30.0, // 设置图片的宽度
                                            height: 30.0, // 设置图片的高度
                                            fit: BoxFit.cover, // 图片填充方式
                                          ),
                                        ),

                                        Transform.translate(
                                          offset: Offset(0.0, -8.0), // 在垂直方向上向上移动20.0
                                          child:Text("Generate",
                                            style: TextStyle(
                                              color: tabIndex == 0? Color(0xffFDB623): Color(0xffd9d9d9),
                                            ),),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: tabIndex ==0,
                                      child: Container(
                                      color: Color(0xffFDB623),
                                      width: 48.0,
                                      height: 4.0,
                                    ))

                                  ],
                                ),
                                SizedBox.shrink(),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Column(
                                      children: [
                                        ICustomButton(
                                          onPressed: () {
                                            _handleSwitchTab(2);
                                          },
                                          icon: Image.asset(
                                            'images/icon-history.png',
                                            color: tabIndex == 2? Color(0xffFDB623): Color(0xffd9d9d9),
                                            width: 30.0, // 设置图片的宽度
                                            height: 30.0, // 设置图片的高度
                                            fit: BoxFit.cover, // 图片填充方式
                                          ),

                                        ),

                                        Transform.translate(
                                          offset: Offset(0.0, -8.0), // 在垂直方向上向上移动20.0
                                          child:Text("History",
                                            style: TextStyle(
                                              color: tabIndex == 2? Color(0xffFDB623): Color(0xffd9d9d9),
                                            ),),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                        visible: tabIndex ==2,
                                        child: Container(
                                          color: Color(0xffFDB623),
                                          width: 48.0,
                                          height: 4.0,
                                        ))

                                  ],
                                ),


                              ],
                            ),
                          ),

                        )

                    ),
                  ),
                  // 富浮动的最大扫描按钮
                  Positioned(
                      top: 640,
                      left: 150,
                      right: 150,
                      bottom: 50, // 设置Container的高度为100
                      child: Container(
                        // color: Colors.red,
                        child: ICustomButton(
                          onPressed:() async {
                            _handleSwitchTab(1);
                          },
                          icon: Image.asset(
                            'images/scanmainbutton1.png',
                            fit: BoxFit.cover, // 图片填充方式
                          ),
                        ),

                      )

                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initDatabase() async {
    try {
      final db = await DBHelper.database;
      print("Database initialized");
    } catch (e) {
      print("Database error: $e");
    }
  }
}





