import '../../_barrel_central.dart';

class MainText extends StatelessWidget {
  const MainText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 65),
      child: AppFonts.bigRich("Organize suas ", "Peladas ", "como um ", "Profissional")
    );
  }
}