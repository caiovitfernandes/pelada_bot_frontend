import 'package:flutter/material.dart';
import 'package:x5_frontend/_barrel_central.dart';

class GreenLargeButton extends StatelessWidget {
  const GreenLargeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 25),
      child: ElevatedButton(
        onPressed: (){
          print("Ok");
        }, 
        child: Row(
          children: [
            Icon(
              Icons.login,
              size: 25
            ),
            SizedBox(width: 5,),
            AppFonts.blackTextButton("Já possuo conta")
          ],
        )
      ),
    );
  }
}