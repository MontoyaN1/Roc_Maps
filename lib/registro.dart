import 'login.dart';
import 'alerta.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final List<Offset> circles = List.generate(
      20,
      (_) => Offset(
        math.Random().nextDouble() * size.width,
        math.Random().nextDouble() * (size.height * 0.4),
      ),
    );

    final TextEditingController nombreController = TextEditingController();
    final TextEditingController correoController = TextEditingController();
    final TextEditingController contrasenaController = TextEditingController();
    final TextEditingController fechaController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            color: Colors.grey[400],
          ),
          SizedBox(
            height: size.height * 0.4,
            width: double.infinity,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(size.width, size.height * 0.4),
                  painter: CircleBackgroundPainter(points: circles),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Image.asset(
                      'assets/images/logo_rocmaps.png',
                      height: 500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.35,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
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
                        "Registro",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Completa el formulario para continuar",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "¿Ya tienes una cuenta?",
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
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
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      buildField(context, "NOMBRE", "Ingrese su nombre",
                          nombreController),
                      const SizedBox(height: 15),
                      buildField(context, "CORREO", "Ingrese su correo",
                          correoController),
                      const SizedBox(height: 15),
                      buildField(context, "CONTRASEÑA", "Ingrese su contraseña",
                          contrasenaController,
                          isPassword: true),
                      const SizedBox(height: 15),
                      buildField(context, "FECHA DE NACIMIENTO",
                          "Ingrese su fecha de nacimiento", fechaController),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            final nombre = nombreController.text.trim();
                            final correo = correoController.text.trim();
                            final contrasena = contrasenaController.text.trim();
                            final fecha = fechaController.text.trim();

                            if (nombre.isEmpty ||
                                correo.isEmpty ||
                                contrasena.isEmpty ||
                                fecha.isEmpty) {
                              llenado(context);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginView(),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Registrarse",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "o",
                              style:
                                  TextStyle(color: Theme.of(context).hintColor),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          icon: Image.asset('assets/images/gogle.png',
                              height: 24),
                          label: const Text("Continuar con Google"),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.mail_outline),
                          label: const Text("Continuar con correo"),
                          onPressed: () {},
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

  Widget buildField(BuildContext context, String label, String hint,
      TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class CircleBackgroundPainter extends CustomPainter {
  final List<Offset> points;

  CircleBackgroundPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 60, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
