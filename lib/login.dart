import 'alerta.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'home.dart';
import 'registro.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
    final TextEditingController contrasenaController = TextEditingController();

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
                child: Padding(
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
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text("NOMBRE",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nombreController,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: "Ingrese su nombre",
                          hintStyle: TextStyle(
                              color: Colors.grey), // texto sugerido visible
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("CONTRASEÑA",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: contrasenaController,
                        obscureText: true,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: "Ingrese su contraseña",
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            final nombre = nombreController.text.trim();
                            final contrasena = contrasenaController.text.trim();

                            if (nombre.isEmpty || contrasena.isEmpty) {
                              llenado(context);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeView(),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Ingresar",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: () {},
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
                                fontWeight: FontWeight.bold),
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
