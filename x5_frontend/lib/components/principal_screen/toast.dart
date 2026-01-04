import '../../_barrel_central.dart';

class Toast extends StatelessWidget {
  const Toast({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

      decoration: BoxDecoration(
        color: AppColors.backgroudOfText,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary, width: 0.5)
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bolt,
            color: AppColors.primary,
            size: 25
          ),
          SizedBox(width: 5,),
          AppFonts.littleGreenText("A nova era das peladas chegou!")
        ]
      ),
    );
  }
}