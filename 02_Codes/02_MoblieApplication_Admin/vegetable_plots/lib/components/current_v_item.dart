import 'package:flutter/material.dart';
import 'package:niku/niku.dart';

class Current_v_Item extends StatelessWidget {
  final String name;
  final String url;
  final int number;
  final double weight;

  const Current_v_Item(this.name, this.url, this.number, this.weight);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10.0),
              topLeft: Radius.circular(10.0),
            ),
          ),
          width: double.infinity,
          child: NikuColumn(
            [
              NikuStack([
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(url),
                ).niku().positioned(top: 0, left: 30),
                Text('$name')
                    .asNiku()
                    .fontWeight(FontWeight.bold)
                    .color(Colors.blue)
                    .niku()
                    .positioned(top: 15, left: 100),
                Text('$number ต้น')
                    .asNiku()
                    .fontWeight(FontWeight.bold)
                    .color(Colors.blue)
                    .niku()
                    .positioned(top: 15, left: 200),
                Text('${weight.toStringAsFixed(1)} Kg')
                    .asNiku()
                    .center()
                    .fontWeight(FontWeight.bold)
                    .color(Colors.blue)
                    .niku()
                    .positioned(top: 15, left: 290),
              ]).niku().width(double.infinity).height(50),
            ],
          )),
    );
  }
}
