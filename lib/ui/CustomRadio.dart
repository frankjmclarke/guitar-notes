import 'package:flutter/material.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return new Container(
      width: deviceHeight / 16,
      margin: new EdgeInsets.all(5.0),
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
            height: deviceHeight / 20,
            width: deviceHeight / 18,
            child: new Center(
              widthFactor: 1,
              child: new Text(_item.buttonText,
                  style: new TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: deviceHeight / 22.0)),
            ),
            decoration: new BoxDecoration(
              color:
                  _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius:
                  const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  int index;
  final pubsub;
  int prev = -1;

  RadioModel(this.isSelected, this.buttonText, this.index, this.pubsub);
}
