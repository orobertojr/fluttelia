import 'package:e_commerce/helpers/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  //final IconData icon;
  final String icon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const RoundedInputField(
      {Key key, this.hintText, this.icon = "", this.onChanged, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            icon: ImageIcon(
              AssetImage(icon),
              color: Colors.black,
              size: 30,
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.blueGrey.shade300),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: -8)),
      ),
    );
  }
}
