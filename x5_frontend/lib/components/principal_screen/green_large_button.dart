import 'package:flutter/material.dart';
import 'package:x5_frontend/_barrel_central.dart';

class GreenLargeButton extends StatelessWidget {
  const GreenLargeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 25),
      child: SizedBox(
        width: 400,
        height: 60,
        child: ElevatedButton(
          onPressed: (){
            print("Ok");
          }, 
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.login,
                size: 25,
              ),
              SizedBox(width: 5,),
              AppFonts.blackTextButton("Já possuo conta")
            ],
          )
        ),
      )
    );
  }
}