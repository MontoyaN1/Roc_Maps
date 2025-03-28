import 'package:ap/Login.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});
  static String id = 'register_view';

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
                // Forma curva blanca
                /* Positioned(
                  bottom: 0,
                  child: ClipPath(
                    clipper: CurvedContainerClipper(),
                    child: Container(
                      height: size.height * 0.1,
                      width: size.width,
                      color: Colors.white,
                    ),
                  ),
                ), */
              ],
            ),
            // Formulario de registro
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  /*  topLeft: Radius.circular(50), */
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Crea una cuenta",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginView(),
                          ),
                        );
                      }, // IR INICIO DE SESIÓN
                      child: const Text("¿Ya estás registrado? Inicia sesión"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("NOMBRE",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  _buildTextField("Ingrese su Nombre"),
                  const SizedBox(height: 20),
                  const Text("CORREO",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  _buildTextField("Ingrese su Correo"),
                  const SizedBox(height: 20),
                  const Text("CONTRASEÑA",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  _buildTextField("Ingrese su Contraseña", obscureText: true),
                  const SizedBox(height: 20),
                  const Text("AÑO DE NACIMIENTO",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  _buildTextField("Ingrese su año de nacimiento",
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginView(),
                          ),
                        );
                      }, //REGISTRARSE
                      child: const Text(
                        "Registrarse",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
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

  Widget _buildTextField(String hintText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// Pinta los círculos verdes en el fondo
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

// Genera la curva en la parte inferior del formulario
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
