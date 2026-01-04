import '../_barrel_central.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MyAppBar(),
      body: SizedBox( 
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Alinhamento vertical
          crossAxisAlignment: CrossAxisAlignment.center, // Alinhamento horizontal
          children: [
            const SizedBox(height: 75.0,),
            Toast(),
            const SizedBox(height: 25.0,),
            MainText(),

          ],
        )
      )
    );
  }
}