import 'package:flutter/material.dart';
import 'package:x5_frontend/styles/app_fonts.dart';

class InitialSmallText extends StatelessWidget {
  const InitialSmallText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: AppFonts.smallGrey("Gerencie grupos, balance times automaticamente, acompanhe rankings e descubra quem são os craques da sua região. Tudo em um só app."),
    );
  }
}