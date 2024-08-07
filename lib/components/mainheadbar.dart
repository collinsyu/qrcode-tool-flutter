import 'package:flutter/material.dart';

import 'i_custom_button.dart';

class MainCommonHeadBar extends StatelessWidget {
  const MainCommonHeadBar({super.key,this.title="title"});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: TextStyle(
              color: Color(0xFFD9D9D9),
              fontSize: 24.0
          ),),
          ICustomButton(
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
    );

  }
}
