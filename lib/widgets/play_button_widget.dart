import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  Function()? onPress;
   PlayButton({this.onPress,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onPress, child: Text("Play"),style: OutlinedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic,),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1)))),);
  }
}
