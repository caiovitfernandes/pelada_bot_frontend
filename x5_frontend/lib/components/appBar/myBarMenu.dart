import '../../_barrel_central.dart';

class MyBarMenu extends StatelessWidget{
  const MyBarMenu({super.key});

  @override
  Widget build(BuildContext context){
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu),
      onSelected: (value) {
        print("Olá");
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value:'teste',
            child: Text('Teste'),
          )
        ];
      },
    );
  }
}