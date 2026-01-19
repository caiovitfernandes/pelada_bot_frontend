import '../_barrel_central.dart';

class AppFonts {
  static const heigtLineBigRich = 1.2;
  static const fontsizeBigRich = 47.0;

  // Estilos
  static const TextStyle _titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.strongText,
  );

  static const TextStyle _titleStyleOne = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.principalText,
  );

  static const TextStyle _titleStyleTwo = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.strongText,
  );

  static const TextStyle _buttonCommon = TextStyle(
    fontSize: 12,
    color: AppColors.minusText,
  );

  static const TextStyle _littleGreenText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle _bigRichOne = TextStyle(
    fontSize: fontsizeBigRich,
    height: heigtLineBigRich,
    fontWeight: FontWeight.bold,
    color: AppColors.principalText,
  );

  static const TextStyle _bigRichTwo = TextStyle(
    fontSize: fontsizeBigRich,
    height: heigtLineBigRich,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle _bigRichThree = TextStyle(
    fontSize: fontsizeBigRich,
    height: heigtLineBigRich,
    fontWeight: FontWeight.bold,
    color: AppColors.principalText,
  );

  static const TextStyle _bigRichFour = TextStyle(
    fontSize: fontsizeBigRich,
    height: heigtLineBigRich,
    fontWeight: FontWeight.bold,
    color: AppColors.contrastText,
  );

  static const TextStyle _smallGrey = TextStyle(
    fontSize: 20,
    height: 1.5,
    fontWeight: FontWeight.normal,
    color: AppColors.minusText,
  );

  static const TextStyle _blackTextButton = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.bold,
    color: AppColors.background,
  ); 

  static const TextStyle _whiteTextButton = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.bold,
    color: AppColors.principalText,
  );  

  static const TextStyle _whiteBigTextCard = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: AppColors.principalText,
  );  

  static const TextStyle _minusGrey = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.normal,
    color: AppColors.minusText,
  );

  // Métodos
  static Text title(String text) => Text(text, style: _titleStyle);
  static Text titleBar(String textOne, String textTwo) => Text.rich(TextSpan(text: textOne, style: _titleStyleOne, children: [TextSpan(text: textTwo, style: _titleStyleTwo)]));
  static Text buttonCommon(String text) => Text(text, style: _buttonCommon,);
  static Text littleGreenText(String text) => Text(text, style: _littleGreenText,);
  static Text bigRich(String textOne, String textTwo, String textThree, String textFour) => Text.rich(TextSpan(text: textOne, style: _bigRichOne, children: [TextSpan(text: textTwo, style: _bigRichTwo), TextSpan(text: textThree, style: _bigRichThree), TextSpan(text: textFour, style: _bigRichFour)]), textAlign: TextAlign.center,);
  static Text smallGrey(String text) => Text(text, style: _smallGrey, textAlign: TextAlign.center,);
  static Text blackTextButton(String text) => Text(text, style: _blackTextButton, textAlign: TextAlign.center,);
  static Text whiteTextButton(String text) => Text(text, style: _whiteTextButton, textAlign: TextAlign.center,);
  static Text whiteBigTextCard(String text) => Text(text, style: AppFonts._whiteBigTextCard, textAlign: TextAlign.center,);
  static Text minusGrey(String text) => Text(text, style: AppFonts._minusGrey, textAlign: TextAlign.center,);
}