

import 'package:ap/Login.dart';
import 'package:flutter/material.dart';

class RecupView extends StatelessWidget {
  const RecupView({super.key});
  static String id = 'login_view';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body:  Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 47, 62, 171),
                gradient: LinearGradient(colors: [(  Color.fromARGB(255, 252, 252, 252)), Color.fromARGB(255, 47, 62, 171)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
            ),
          ),
          Center(  
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

             Image.asset("assets/images/chef.jpg"),
            // email
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1,
                vertical: size.height * 0.05,
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Ingresa tu correo para recuperar la contraseña',
                  labelStyle: TextStyle(
                    color: Color(0xFFBEBCBC),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onChanged: (value) {},
              ),
            ),  
            
            GestureDetector(
                    child: const Text(
                      "Enviar correo de recuperacion",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    onTap: () {
                      showDialog(     
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0) ),
        content: Column( 
            mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          const Text("Su correo de recuperacion a sido enviado"), 
           Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              child: const Text("Volver a inicio"),
              onPressed:()async{
                Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView()
                          )
                          );

          },
         ),
        ]
       )
      ]
     )
    );
                    }
                      );
                    }
            ),
          ],
        ),
      ),
      ],
      )
    
    );
  }
}