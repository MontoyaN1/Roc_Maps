import 'package:provider/provider.dart';
import 'package:rocmaps/alerta.dart';
import 'package:rocmaps/auth_provider.dart';
import 'package:rocmaps/recupcontra.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'registro.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            color: Colors.grey[400],
          ),
          Container(
            height: size.height * 0.4,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFDFDFD), // Blanco
                  Color(0xFF16A35D), // Verde
                ],
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

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(60),
              ),
              child: Container(
                height: size.height * 0.65,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Inicia sesión para continuar",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "CORREO",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: emailController,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: "Ingrese su Correo Electrónico",
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF16A35D), // verde del splash
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF16A35D),
                              width: 2.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        "CONTRASEÑA",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: contrasenaController,
                        obscureText: true,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: "Ingrese su contraseña",
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(
                                0xFF16A35D,
                              ), // mismo verde del splash
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF16A35D),
                              width: 2.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF16A35D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            final correo = emailController.text.trim();
                            final contrasena = contrasenaController.text.trim();

                            if (correo.isEmpty || contrasena.isEmpty) {
                              llenado(context);
                            } else {
                              final auth = context.read<AuthProvider>();
                              final user = await auth.signInWithEmailPassword(
                                correo,
                                contrasena,
                              );
                              if (user != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeView(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Correo electrónico o contraseña incorrectos',
                                    ), // Mensaje de error en la interfaz
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            "Ingresar",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          icon: Image.asset(
                            'assets/images/gogle.png',
                            height: 24,
                          ),
                          label: const Text("Continuar con Google"),
                          onPressed: () async {
                            final auth = context.read<AuthProvider>();
                            await auth.loginGoogle();

                            if (auth.isLoggedIn) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeView(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Fallo autenticación de Google',
                                  ), // Mensaje de error en la interfaz
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RecupView(),
                              ),
                            );
                          },
                          child: const Text(
                            "¿Olvidaste tu clave?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterView(),
                              ),
                            );
                          },
                          child: const Text(
                            "Crea una cuenta",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
