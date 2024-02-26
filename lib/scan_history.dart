import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/sqlite/qrcodeGenHistory.dart';
import './sqlite/qrcodedata.dart';
import 'models/QrCodeItem.dart';

class ScanHistory extends StatefulWidget {
  const ScanHistory({super.key});

  @override
  State<ScanHistory> createState() => _ScanHistoryState();
}

class _ScanHistoryState extends State<ScanHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;


  late List<QrCodeItem> list = [];

  void queryList() async {
    List<QrCodeItem> _list = await QrcodeScanHistory.listsQrcode(); // Prints a list that include Fido.

    setState(()  {
      list = _list;

      print(_list);
    });
  }



  late List<QrCodeItem> list1 = [];

  void queryList1() async {
    List<QrCodeItem> _list1 = await QrcodeGenHistory.listsQrcode(); // Prints a list that include Fido.

    setState(()  {
      list1 = _list1;

    });
  }


  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    queryList();
    queryList1();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "History",
                          style: TextStyle(
                              color: Color(0xFFD9D9D9), fontSize: 24.0),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/setting');
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              color: Color(0xcc333333),

                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)), // 设置所有角的圆角半径为10.0
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'images/icon-setting-inner.png',
                              width: 24.0, // 设置图片的宽度
                              height: 24.0, // 设置图片的高度
                              fit: BoxFit.cover, // 图片填充方式
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //   grid
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Color(0xcc333333),
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0)), // 设置所有角的圆角半径为10.0
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xffFDB623), // 渐变的起始颜色
                              Color(0xff333333), // 渐变的起始颜色
                            ],
                          ),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      tabs: <Widget>[
                        Tab(
                          child: Text(
                            "scan",
                            style: TextStyle(
                                color: Color(0xffffffff), fontSize: 18.0),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Create",
                            style: TextStyle(
                                color: Color(0xffffffff), fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 8.0,
                  ),

                  //   列表内容
                  Container(
                    height: MediaQuery.of(context).size.height - 300.0,
                    child: TabBarView(
                      controller: _tabController ?? null,
                      children: <Widget>[
                        SingleChildScrollView(
                            child: Column(
                          children: list.map((e) {
                            return  ScanListItem(data:e,clickDelete:(int? id) async {
                              print("delete item id:" + id.toString());
                              if(id!= null){
                                await QrcodeScanHistory.deleteQrcode(id!);
                                queryList();

                              }

                            });
                          }).toList()
                          
                        )),
                        SingleChildScrollView(
                            child: Column(
                          children: list1.map((e) {
                            return  GenListItem(data:e,clickDelete:(int? id) async {
                              print("delete item id:" + id.toString());
                              if(id!= null){
                                await QrcodeGenHistory.deleteQrcode(id!);
                                queryList1();

                              }

                            });
                          }).toList(),
                        )),
                      ],
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

}

class ScanListItem extends StatelessWidget {

  QrCodeItem? data;
  final ValueChanged<int?> clickDelete;

  ScanListItem({super.key, required this.data,required this.clickDelete});
  
  @override
  Widget build(BuildContext context) {
    // print(data?.toString());
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail',arguments: data!.id);

      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Color(0xcc333333),
            borderRadius: BorderRadius.all(Radius.circular(10.0)), //
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 16.0, 0),
                child: Image.asset(
                  'images/list-type-text.png',
                  width: 33.0, // 设置图片的宽度
                  height: 33.0, // 设置图片的高度
                  fit: BoxFit.cover, // 图片填充方式
                ),
              ),
              Expanded(
                  child: Container(
                    // color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child:  Container(child: Text(
                              data?.value??'-',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Color(0xffD9D9D9), fontSize: 17,overflow: TextOverflow.ellipsis),
                            ))),
                            Container(
                              height: 24.0,
                              width: 24.0,
                              child: IconButton(
                                onPressed: () {
                                  clickDelete(data!.id);
                                },
                                padding: EdgeInsets.all(0.0),
                                icon: Image.asset(
                                  'images/icon-delete.png',
                                  fit: BoxFit.cover, // 图片填充方式
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Data",
                                style: TextStyle(
                                    color: Color(0xffA4A4A4), fontSize: 11)),
                            Text(data?.date??'-',
                                style: TextStyle(
                                    color: Color(0xffA4A4A4), fontSize: 11)),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          )),
    );

  }
}



class GenListItem extends StatelessWidget {

  QrCodeItem? data;
  final ValueChanged<int?> clickDelete;

  GenListItem({super.key, required this.data,required this.clickDelete});

  @override
  Widget build(BuildContext context) {
    // print(data?.toString());
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail_gen',arguments: data!.id);

      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Color(0xcc333333),
            borderRadius: BorderRadius.all(Radius.circular(10.0)), //
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 16.0, 0),
                child: Image.asset(
                  'images/list-type-text.png',
                  width: 33.0, // 设置图片的宽度
                  height: 33.0, // 设置图片的高度
                  fit: BoxFit.cover, // 图片填充方式
                ),
              ),
              Expanded(
                  child: Container(
                    // color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child:  Container(child: Text(
                              data?.value??'-',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                              TextStyle(color: Color(0xffD9D9D9), fontSize: 17,overflow: TextOverflow.ellipsis),
                            ))),
                            Container(
                              height: 24.0,
                              width: 24.0,
                              child: IconButton(
                                onPressed: () {
                                  clickDelete(data!.id);
                                },
                                padding: EdgeInsets.all(0.0),
                                icon: Image.asset(
                                  'images/icon-delete.png',
                                  fit: BoxFit.cover, // 图片填充方式
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Data",
                                style: TextStyle(
                                    color: Color(0xffA4A4A4), fontSize: 11)),
                            Text(data?.date??'-',
                                style: TextStyle(
                                    color: Color(0xffA4A4A4), fontSize: 11)),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          )),
    );

  }
}
