import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import './scanner_error_widget.dart';
import './sqlite/qrcodedata.dart';
import 'package:intl/intl.dart';

import 'models/QrCodeItem.dart';




class BarcodeScannerWithOverlay extends StatefulWidget {
  @override
  _BarcodeScannerWithOverlayState createState() =>
      _BarcodeScannerWithOverlayState();
}

class _BarcodeScannerWithOverlayState extends State<BarcodeScannerWithOverlay> {
  String overlayText = "Please scan QR Code";
  bool camStarted = false;

  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    autoStart: false,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void startCamera() {
    if (camStarted) {
      return;
    }

    controller.start().then((_) {
      if (mounted) {
        setState(() {
          camStarted = true;
        });
      }
    }).catchError((Object error, StackTrace stackTrace) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong! $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
  void handleSaveData(String? s) async {
    String value = s?? 'null';
    // Create a Dog and add it to the dogs table


    DateTime now = DateTime.now();

    DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
    String formattedDate = formatter.format(now);

    var example = QrCodeItem(
      // id: 0,
      value: value,
      type: "text",
      date: formattedDate
    );

    int? newId = await QrcodeScanHistory.insertQrcode(example);
    print(newId);
    Navigator.pushNamed(context, '/detail',arguments: newId);


  }

  void onBarcodeDetect(BarcodeCapture barcodeCapture) async {
    final barcode = barcodeCapture.barcodes.last;
    //
    if((barcodeCapture.barcodes.last.displayValue ?? barcode.rawValue) !=null){

      handleSaveData(barcodeCapture.barcodes.last.displayValue ?? barcode.rawValue);

    }

    setState(() {
      overlayText = barcodeCapture.barcodes.last.displayValue ??
          barcode.rawValue ??
          'Barcode has no displayable value';
    });
  }

  @override
  void initState() {
    super.initState();
    print("scan === init");
    startCamera();
  }


  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 200,
      height: 200,
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Stack(
                    children: [
                      MobileScanner(
                        fit: BoxFit.fitHeight,
                        onDetect: onBarcodeDetect,
                        // overlay: Padding(
                        //   padding: const EdgeInsets.all(16.0),
                        //
                        // ),
                        controller: controller,
                        scanWindow: scanWindow,
                        errorBuilder: (context, error, child) {
                          return ScannerErrorWidget(error: error);
                        },
                      ),
                      CustomPaint(
                        painter: ScannerOverlay(scanWindow),
                      ),
                      // 扫描图片

                      Center(
                        child:  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  'images/scan.png',
                                  width: 240.0, // 设置图片的宽度
                                  height: 240.0, // 设置图片的高度
                                  fit: BoxFit.cover, // 图片填充方式
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 顶部按钮
                      Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        height: 120.0,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 32.0, horizontal: 48.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xaa333333),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)), // 设置所有角的圆角半径为10.0
                              ),
                              height: 100.0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      color: Colors.white,
                                      icon: Image.asset(
                                        color: Color(0xffd9d9d9),
                                        'images/icon-images.png',
                                        width: 25.0, // 设置图片的宽度
                                        height: 25.0, // 设置图片的高度
                                        fit: BoxFit.cover, // 图片填充方式
                                      ),
                                      iconSize: 32.0,
                                      onPressed: () async {
                                        final ImagePicker picker =
                                        ImagePicker();
                                        // Pick an image
                                        final XFile? image = await picker.pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        if (image != null) {
                                          startCamera();

                                          if (await controller.analyzeImage(image.path)) {
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text('Barcode found!'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } else {
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                Text('No barcode found!'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );

                                          }
                                        } else{
                                          print("no iumage selected");


                                        }
                                        controller.start();

                                      },
                                    ),
                                    ValueListenableBuilder<TorchState>(
                                      valueListenable: controller.torchState,
                                      builder: (context, value, child) {
                                        final Color iconColor;

                                        switch (value) {
                                          case TorchState.off:
                                            iconColor = Color(0xffd9d9d9);
                                          case TorchState.on:
                                            iconColor = Colors.yellow;
                                        }
                                        return IconButton(
                                          onPressed: () =>
                                              controller.toggleTorch(),
                                          icon: Image.asset(
                                            color: iconColor,
                                            'images/icon-flash.png',
                                            width: 17.0, // 设置图片的宽度
                                            height: 25.0, // 设置图片的高度
                                            fit: BoxFit.cover, // 图片填充方式
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          controller.switchCamera(),
                                      icon: Image.asset(
                                        color: Color(0xffd9d9d9),
                                        'images/icon-camera-turn.png',
                                        width: 25.0, // 设置图片的宽度
                                        height: 25.0, // 设置图片的高度
                                        fit: BoxFit.cover, // 图片填充方式
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),

                  // 底部menu

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;
  final double borderRadius = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    // Create a Paint object for the white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0; // Adjust the border width as needed

    // Calculate the border rectangle with rounded corners
// Adjust the radius as needed
    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // Draw the white border
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
