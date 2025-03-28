import 'package:ap/Home.dart';
import 'package:ap/Registro.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Fondo con patrón de círculos y logo
            Stack(
              children: [
                Container(
                  height: size.height * 0.4,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0E0E0), // Color grisáceo de fondo
                  ),
                  child: CustomPaint(
                    painter:
                        CirclePatternPainter(), // Pinta los círculos verdes
                    child: Center(
                      child: Image.asset(
                        "assets/images/logo_rocmaps.png",
                        width: size.width * 0.9,
                        height: size.height * 0.9,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  /* topLeft: Radius.circular(50), */
                  topRight: Radius.circular(50),
                ),
              ),
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
                  const SizedBox(height: 5),
                  const Text(
                    "Inicia sesión para continuar",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "NOMBRE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Ingrese su nombre",
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "CONTRASEÑA",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Ingrese su contraseña",
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeView(),
                              ),
                            );
                          }, //INGRESA PANTALLA PRINCIPAL
                          child: const Text(
                            "Ingresar",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Image.asset(
                                "assets/images/google_continue_dark.png",
                              )),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "¿Olvidaste tu clave?",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  TextButton(
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dibuja los círculos verdes de fondo
class CirclePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 10; i++) {
      final x = math.Random().nextDouble() * size.width;
      final y = math.Random().nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 20, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Crea la curva del contenedor blanco inferior
class CurvedContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width / 2, size.height * 1.2, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
