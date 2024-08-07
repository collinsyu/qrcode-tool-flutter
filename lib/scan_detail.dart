import 'dart:ui' as ui;
import 'dart:ui';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qrcode/components/i_custom_button.dart';
import 'package:vibration/vibration.dart';
import './sqlite/qrcodedata.dart';
import './tools/saveimage.dart';
import 'components/headbar.dart';
import 'core/setting.dart';
import 'models/QrCodeItem.dart';

class ScanDetail extends StatefulWidget {
  final int id;
  const ScanDetail({super.key, required this.id});

  @override
  State<ScanDetail> createState() => _ScanDetailState();
}

class _ScanDetailState extends State<ScanDetail> with TickerProviderStateMixin {
  late int id;
  QrCodeItem? codeinfo;
  bool isShowQrcode = false;
  void queryDetail() async {
    QrCodeItem? _data = await QrcodeScanHistory.getQrCodeById(id);
    setState(() {
      codeinfo = _data;
    });
  }

  @protected
  late QrCode qrCode;

  @protected
  late QrImage qrImage;


  @override
  void initState() {
    super.initState();
    id = widget.id;

    queryDetail();
    qrCode = QrCode.fromData(
      data: 'https://pub.dev/packages/pretty_qr_code',
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    qrImage = QrImage(qrCode);

  }

  @override
  void dispose() {
    super.dispose();
  }
  GlobalKey _repaintKey = GlobalKey(); // 可以获取到被截图组件状态的 GlobalKey

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
                children: [
                  CommonHeadBar(title: 'Result'),



                  Container(
                      margin: EdgeInsets.symmetric(vertical: 25.0,horizontal: 10.0),
                      padding: EdgeInsets.fromLTRB(16.0,16.0,16.0,0),
                      decoration: BoxDecoration(
                        color: Color(0xcc333333),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)), //
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 16.0, 0),
                                child:  codeinfo?.format == 1?Image.asset(
                                  'images/list-cormat-barcode.png',
                                  width: 49.0, // 设置图片的宽度
                                  height: 49.0, // 设置图片的高度
                                  fit: BoxFit.cover, // 图片填充方式
                                ):Image.asset(
                                  'images/list-type-text.png',
                                  width: 49.0, // 设置图片的宽度
                                  height: 49.0, // 设置图片的高度
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
                                        Text(
                                          'Data',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style:
                                          TextStyle(color: Color(0xffD9D9D9), fontSize: 22,overflow: TextOverflow.ellipsis),
                                        ),
                                        Text(codeinfo?.date??'-',
                                            style: TextStyle(
                                                color: Color(0xffA4A4A4), fontSize: 13)),

                                      ],
                                    ),
                                  )
                              ),

                              GestureDetector(onTap: () async {
                                if(SettingConfig.ISVIBRATE){
                                  await Vibration.vibrate(duration: 50); // 500毫秒

                                }
                                // copy data
                                final textToCopy = codeinfo?.value??'-';

                                // 获取系统剪贴板
                                Clipboard.setData(ClipboardData(text: textToCopy));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Copied to clipboard')),
                                );
                              },child: Icon(Icons.content_copy,color: Color(0xffD9D9D9),),)
                            ],
                          ),
                          Divider(
                            thickness: 0.3,
                            height: 32,
                            color: Color(0xff858585),
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxHeight: 120
                            ),
                            child: SingleChildScrollView(
                                child: Text(codeinfo?.value??'-',
                                  style: TextStyle(
                                      color: Color(0xffD9D9D9),

                                      fontSize: 17
                                  ),)
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(onPressed: () async {
                                if(SettingConfig.ISVIBRATE){
                                  await Vibration.vibrate(duration: 50); // 500毫秒

                                }
                                setState(() {
                                  isShowQrcode = !isShowQrcode;
                                });
                              },
                                  style: ButtonStyle(

                                  ),
                                  child: Text(!isShowQrcode?"Show Bar Code":"Hide Bar Code",style: TextStyle(
                                  color: Color(0xffFDB623),
                                  fontSize: 15
                              ),)),
                            ],
                          ),




                          

                        ],
                      )
                  ),

                //   qrcode

                  Visibility(
                    visible: isShowQrcode,
                    child: RepaintBoundary(
                      key: _repaintKey,
                      child: Container(
                        height: 200,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),

                        ),
                        child: codeinfo?.format == 1?BarcodeWidget(
                          barcode: Barcode.code128(), // Barcode type and settings
                          data: codeinfo!.value, // Content
                          width: 200,
                          height: 200,
                        ):PrettyQrView(
                      qrImage:QrImage(QrCode.fromData(
                        data: codeinfo!.value,
                        errorCorrectLevel: QrErrorCorrectLevel.H,
                      )),
                    decoration: const PrettyQrDecoration(
                      shape: PrettyQrSmoothSymbol(
                          color: Color(0xff000000),
                          roundFactor:0
                      ),

                    ),
                  ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isShowQrcode,
                    child: ICustomButton(onPressed: () async {
                    //   保存图片到本地
                      if (await Permission.storage.request().isGranted) {
                        Uint8List? imgdata = await _getImageData(_repaintKey);
                        print("获取到到image信息");
                        print(imgdata);
                        if(imgdata !=null){
                          await ImageGallerySaver.saveImage(imgdata);

                        //   给一个提示

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                              const SnackBar(
                                content: Text('保存成功!'),
                                backgroundColor: Colors.green,
                              )
                          );

                        }
                      } else {
                        // 没有存储权限时，弹出没有存储权限的弹窗
                        print("没有获取存储权限");

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                            const SnackBar(
                              content: Text('请在设置中打开读取文件权限'),
                              backgroundColor: Colors.orange,
                            )
                        );
                        await [Permission.storage].request();

                      }

                      // SaveToAlbumUtil.saveToAlbum(qrImage);
                    }, icon: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xffFDB623),

                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)), // 设置所有角的圆角半径为10.0
                      ),
                      child: Icon(Icons.save,size: 36,),
                    )),
                  )

                ],
              ),
            ),
          ])),

    );
  }



  /// 获取截取图片的数据
  Future<Uint8List?> _getImageData(_repaintKey) async {
    BuildContext buildContext = _repaintKey.currentContext;
    if (buildContext != null) {
      RenderRepaintBoundary? boundary = buildContext.findRenderObject() as RenderRepaintBoundary?;
      // 第一次执行时，boundary.debugNeedsPaint 为 true，此时无法截图（如果为true时直接截图会报错）
      if (boundary!.debugNeedsPaint) {
        // 延时一定时间后，boundary.debugNeedsPaint 会变为 false，然后可以正常执行截图的功能
        await Future.delayed(Duration(milliseconds: 20));
        // 重新调用方法
        return _getImageData(_repaintKey);
      }
      // 获取当前设备的像素比
      double dpr = ui.window.devicePixelRatio;
      // pixelRatio 代表截屏之后的模糊程度，因为不同设备的像素比不同
      // 定义一个固定数值显然不是最佳方案，所以以当前设备的像素为目标值
      ui.Image image = await boundary.toImage(pixelRatio: dpr);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List? imageBytes = byteData?.buffer.asUint8List();
      // 返回图片的数据
      return imageBytes;
    }
  }

}
