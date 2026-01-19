import '../../_barrel_central.dart';

class SquaredCard {
  static Container createSquaredCard(IconData icon, String bigText, String smallText){
    return Container(
      width: 185,
      height: 135,
      decoration: BoxDecoration(
        color: AppColors.backgroundBar.withValues(alpha: 0.5),
        border: Border.all(
          color: AppColors.minusText,
          width: 0.2
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 35,
            color: AppColors.primary,
          ),
          SizedBox(height: 1,),
          AppFonts.whiteBigTextCard(bigText),
          SizedBox(height: 1,),
          AppFonts.minusGrey(smallText)
        ],
      ),
    );
  }
}