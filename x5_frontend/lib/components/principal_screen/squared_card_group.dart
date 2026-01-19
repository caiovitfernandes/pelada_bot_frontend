import '../../_barrel_central.dart';

class SquaredCardGroup extends StatelessWidget {
  const SquaredCardGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SquaredCard.createSquaredCard(Icons.people_alt_outlined, "100+", "Jogadores"),
            SizedBox(width: 20,),
            SquaredCard.createSquaredCard(Icons.emoji_events_outlined, "10+", "Grupos Ativos")
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SquaredCard.createSquaredCard(Icons.local_fire_department_outlined, "1000+", "Partidas/Mês"),
            SizedBox(width: 20,),
            SquaredCard.createSquaredCard(Icons.adjust_outlined, "1+", "Cidades")
          ],
        )
      ],
    );
  }
}