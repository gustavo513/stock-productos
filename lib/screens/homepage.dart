import 'package:flutter/material.dart';
import 'package:repaso10/routes/routes.dart';

class HomePage extends StatelessWidget{
  const HomePage( {super.key} );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Inicio',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ),
        backgroundColor: Colors.blue,
      ),
      body: buildImage(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed(Routes.PRODUCTOS_LIST);
        },
        child: const Icon(Icons.arrow_forward, color: Colors.blue),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget buildImage(){
      return const Row(
        children: [
          Expanded(
            child: Image(
                image: NetworkImage('https://c0.wallpaperflare.com/preview/583/859/760/flat-lay-photography-of-silver-apple-products.jpg'),
                height: 550,
                fit: BoxFit.cover
              ),
            ),
        ],
      );
    }
}