import 'package:flutter/material.dart';

class DynamicForm extends StatelessWidget {
  const DynamicForm({super.key, required this.schemaData, required this.textFormFieldChanged});


  final List<dynamic> schemaData;
  final Function (Map item,String value) textFormFieldChanged;

  /// 构建表单
  List<Widget> _buildForm(List<dynamic> data) {
    List<Widget> widgets = [];
    for (var item in data) {
      switch (item['type']) {
        case 'input':
          widgets.add(Column(
            mainAxisAlignment: MainAxisAlignment.start,
crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['title'],style: TextStyle(
                  color: Color(0xffD9D9D9),
                  fontSize: 14.0
              ),),
              SizedBox(height: 8.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Color(0xff444444),
                  borderRadius:BorderRadius.all(Radius.circular(10.0)),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    // labelText: item['title'],
                    hintText:item['hint'],
                    hintStyle: TextStyle(
                      color: Color(0x66D9D9D9)
                    ),
                    border: InputBorder.none
                  ),
                  onChanged: (value) => textFormFieldChanged(item, value),
                ),
              ),
            ],
          ));
          break;
        case 'checkbox':
          List<Widget> options = [];
          for (var option in item['options']) {
            options.add(Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                Text(option['label']),
              ],
            ));
          }
          widgets.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['title']),
              Column(children: options),
            ],
          ));
          break;
        case 'FcRow':
          List<Widget> children = _buildForm(item['children']);
          widgets.add(Row(children: children));
          break;
        case 'col':
          int span = item['props']['span'];
          List<Widget> colChildren = _buildForm(item['children']);
          if (span > 0 && span <= 24) {
            widgets.add(Expanded(
              flex: span,
              child: Column(children: colChildren),
            ));
          } else {
            widgets.add(Column(children: colChildren));
          }
          break;
        case 'el-button':
          widgets.add(ElevatedButton(
            onPressed: () {},
            child: Text(item['children'][0]),
          ));
          break;
        default:
          break;
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildForm(schemaData),
    );
  }
}
