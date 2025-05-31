import 'package:provider/provider.dart';
import 'package:rocmaps/auth_provider.dart';
import 'package:rocmaps/home.dart';
import 'login.dart';
import 'alerta.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController confirmarContrasenaController =
      TextEditingController();

  @override
  void dispose() {
    correoController.dispose();
    contrasenaController.dispose();
    confirmarContrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[400],
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: size.height * 0.35,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFDFDFD), Color(0xFF16A35D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Image.asset(
                    'assets/images/logo_rocmaps.png',
                    height: 200,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Registro",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Completa el formulario para continuar",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "¿Ya tienes una cuenta?",
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginView(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Inicia sesión",
                                style: TextStyle(color: Color(0xFF16A35D)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildLabel("CORREO"),
                        buildTextField(
                          correoController,
                          "Ingrese su Correo Electrónico",
                        ),
                        const SizedBox(height: 20),
                        buildLabel("CONTRASEÑA"),
                        buildTextField(
                          contrasenaController,
                          "Ingrese una contraseña con más de 6 caracteres",
                          obscure: true,
                        ),
                        const SizedBox(height: 20),
                        buildLabel("CONFIRMAR CONTRASEÑA"),
                        buildTextField(
                          confirmarContrasenaController,
                          "Repita la contraseña",
                          obscure: true,
                        ),
                        const SizedBox(height: 25),
                        buildRegisterButton(),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                "o",
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildGoogleButton(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) =>
      Text(text, style: const TextStyle(fontWeight: FontWeight.bold));

  Widget buildTextField(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: buildDecoration(hint),
    );
  }

  InputDecoration buildDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF16A35D), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF16A35D), width: 2.5),
      ),
    );
  }

  Widget buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF16A35D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          final correo = correoController.text.trim();
          final contrasena = contrasenaController.text.trim();
          final confirmar = confirmarContrasenaController.text.trim();

          if (correo.isEmpty || contrasena.isEmpty || confirmar.isEmpty) {
            llenado(context);
          } else if (contrasena.length < 6) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Debe tener más de 6 caracteres')),
            );
          } else if (contrasena != confirmar) {
            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    title: const Text("Error"),
                    content: const Text("Ambas contraseñas deben ser iguales"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
            );
          } else {
            final auth = context.read<AuthProvider>();
            final usuarioCreado = await auth.createUserEmailPass(
              correo,
              contrasena,
            );

            if (usuarioCreado.isSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("${usuarioCreado.error}")));
            }
          }
        },
        child: const Text(
          "Registrarse",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        icon: Image.asset('assets/images/gogle.png', height: 24),
        label: const Text("Continuar con Google"),
        onPressed: () async {
          final auth = context.read<AuthProvider>();
          await auth.loginGoogle();

          if (auth.isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fallo autenticación de Google')),
            );
          }
        },
      ),
    );
  }
}
