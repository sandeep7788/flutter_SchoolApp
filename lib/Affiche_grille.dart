import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/helper/Util.dart';

class Affiche_grille extends StatefulWidget {
  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<Affiche_grille> {
  List<RadioModel> sampleData = [];
  List<int> groupValue = [];
  List<List<int>> value = [];

  @override
  void initState() {
    super.initState();

    sampleData.add(new RadioModel(false, 'A', 'April 18', 'text1'));
    sampleData.add(new RadioModel(false, 'B', 'April 17', 'text2'));
    sampleData.add(new RadioModel(false, 'C', 'April 16', 'text3'));
    sampleData.add(new RadioModel(false, 'D', 'April 15', 'text4'));

    groupValue.add(0);
    groupValue.add(2);
    groupValue.add(4);
    groupValue.add(6);

    value.add([0, 1]);
    value.add([2, 3]);
    value.add([4, 5]);
    value.add([6, 7]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ListItem"),
      ),
      body: ListView.builder(
        itemCount: sampleData.length,
        itemBuilder: (context, index) => ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
              groupValue: groupValue[index],
              value: value[index][0],
              onChanged: (val) {
               setState(() {
                 setState(() => groupValue[index] = val);
                     log.fine(groupValue.toString());
                     log.fine(value.toString());
                     log.fine(val.toString());
               });
              },
            ),
            Radio(
              groupValue: groupValue[index],
              value: value[index][1],
              onChanged: (newValue) =>
                  setState(() => groupValue[index] = newValue),
            ),
          ],
        ),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;
  final String text1;

  RadioModel(this.isSelected, this.buttonText, this.text, this.text1);
}
