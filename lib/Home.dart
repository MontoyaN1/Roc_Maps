import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "xd",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          endDrawer: Drawer(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                          onPressed: () {},
                          child: const Icon(Icons.arrow_back)),
                    ],
                  ),
                  Image.asset("assets/images/logo_rocmaps.png")
                ],
              ),
            ),
          ),
          appBar: AppBar(),
          body: const Center(
            child: Text("xd"),
          )),
    );
  }
}
