import '../../_barrel_central.dart';

class TransparentLargeButton extends StatelessWidget {
  const TransparentLargeButton({super.key});

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
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.principalText,
            side: const BorderSide(
              color: AppColors.primary,
              width: 0.5
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppFonts.whiteTextButton("Criar uma conta"),
              SizedBox(width: 5,),
              Icon(
                Icons.arrow_forward,
                size: 25,
              ),
            ],
          )
        ),
      )
    );
  }
}