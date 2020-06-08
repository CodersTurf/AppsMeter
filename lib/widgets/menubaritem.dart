import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuBarItem extends StatelessWidget {
  final String headerText;
  final String headerKey;
  final Function onTapEvent;
  final bool isSelected;
  MenuBarItem(
      this.headerText, this.headerKey, this.isSelected, this.onTapEvent);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onTapEvent(headerKey);
        },
        child: Container(
            width: 130.0,
            child: Center(
                child: Text(
              headerText,
              style: TextStyle(
                  fontSize: isSelected ? 17 : 16,
                  color: isSelected ? Colors.white : Colors.white70),
            ))));
  }
}
