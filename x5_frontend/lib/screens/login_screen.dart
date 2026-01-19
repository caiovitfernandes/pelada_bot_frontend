import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idController = TextEditingController();
  final _passController = TextEditingController();

  void _entrar() async {
    // Mostra um carregando
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: X5Colors.primaryGreen)),
    );

    try {
      bool ok = await ApiService().authAdmin(_idController.text, _passController.text);
      
      Navigator.pop(context); // Fecha o carregando

      if (ok) {
        // Passamos o texto do controlador para a próxima tela
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(peladaId: _idController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Acesso Negado: ID ou Senha incorretos")),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Fecha o carregando
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro de conexão: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_volleyball, size: 80, color: X5Colors.primaryGreen),
            const SizedBox(height: 20),
            const Text("X5 BOT", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            TextField(controller: _idController, decoration: const InputDecoration(labelText: "ID da Pelada")),
            TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: "Senha Admin")),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _entrar,
              style: ElevatedButton.styleFrom(backgroundColor: X5Colors.primaryGreen, minimumSize: const Size(double.infinity, 50)),
              child: const Text("ENTRAR", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}