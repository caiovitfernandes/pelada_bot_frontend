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
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/sports3.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  AppColors.background.withValues(alpha: 0.125),
                  BlendMode.dstATop
                ),
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Alinhamento vertical
              crossAxisAlignment: CrossAxisAlignment.center, // Alinhamento horizontal
              children: [
                const SizedBox(height: 75.0,),
                Toast(),
                const SizedBox(height: 25.0,),
                MainText(),
                const SizedBox(height: 25.0,),
                InitialSmallText(),
                const SizedBox(height: 25.0,),
                GreenLargeButton(),
                const SizedBox(height: 15.0,),
                TransparentLargeButton(),
                const SizedBox(height: 45.0,),
                SquaredCardGroup(),
                const SizedBox(height: 45.0,),
              ],
            )
          )
        )
      )
    );
  }
}