import '../../_barrel_central.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Gerais
      toolbarHeight: 65.0,
      backgroundColor: AppColors.backgroundBar,

      // Lado esquerdo
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'images/icon1.png',
          fit: BoxFit.contain,
        ),
      ),

      // Centro
      centerTitle: true,
      title: AppFonts.titleBar("X5", "Bot"),
      
      // Lado direito
      actions: [
        // Imagem usuário
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'images/user.png',
            fit: BoxFit.contain,
          )
        ),

        // Menu
        MyBarMenu()
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65.0);
}