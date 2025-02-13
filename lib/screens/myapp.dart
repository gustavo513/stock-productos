import 'package:flutter/material.dart';
import 'package:repaso10/screens/formpage.dart';
import 'package:repaso10/screens/homepage.dart';
import 'package:repaso10/screens/productospage.dart';

class MyApp extends StatelessWidget{
  const MyApp( {super.key} );

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Productos',
      routes: {
        '/': (context) => const HomePage(),
        '/productoslistpage': (context) => const ProductosPage(),
        '/productoformpage': (context) => const ProductoFormPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}