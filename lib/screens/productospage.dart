import 'package:flutter/material.dart';
import 'package:repaso10/models/producto.dart';
import 'package:repaso10/routes/routes.dart';
import 'package:repaso10/services/productosServices.dart';

class ProductosPage extends StatefulWidget{
  const ProductosPage( {super.key} );

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage>{

  void actualizarEstado(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Productos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )
          )
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: _buildMenuBar(),
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: _buildLateralMenu(),
      body: generateProductosList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.of(context).pushNamed(Routes.PRODUCTOS_FORM);
          actualizarEstado();
        },
        child: const Icon(Icons.add, color: Colors.blue),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildMenuBar(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 40,),
        IconButton(
          onPressed: (){
            Navigator.of(context).pushNamed(Routes.HOME);
          },
          icon: const Icon(Icons.home, color: Colors.white),
        ),
        const SizedBox(width: 20,),
        IconButton(
          onPressed: (){
             Navigator.of(context).pushNamed(Routes.PRODUCTOS_LIST);           
          },
          icon: const Icon(Icons.list, color: Colors.white),
        ),
        const SizedBox(width: 20,),
        IconButton(
          onPressed: () async{
            await Navigator.of(context).pushNamed(Routes.PRODUCTOS_FORM);
            actualizarEstado();
          },
          icon: const Icon(Icons.add_box_outlined, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildLateralMenu(){
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )
            )
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: (){
              Navigator.of(context).pushNamed(Routes.HOME);
            }
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Productos'),
            onTap: (){
              Navigator.of(context).pushNamed(Routes.PRODUCTOS_LIST);
            }
          )
        ]
      ),
    );
  }

  Widget generateProductosList(BuildContext context){
    
    return FutureBuilder(
      future: getProductos(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildCards(snapshot.data![index]);
              },
            );
        }
        else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildCards(Producto producto){

    String? mensaje;

    if(producto.disponibilidad == true){
      mensaje = 'Disponible';
    }
    else{
      mensaje = 'No Disponible';
    }

    return Container(
      margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      Text('Descripcion: ${producto.descripcion}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Categoria: ${producto.categoria}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Precio: ${producto.precio}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('ID Producto: ${producto.idProducto}', style: const TextStyle(fontWeight: FontWeight.bold)),             
                ],
              ),
            ),
          ),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5)
                      ),
                      color: producto.disponibilidad == true? Colors.green : Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        mensaje,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async{
                          await Navigator.of(context).pushNamed(Routes.PRODUCTOS_FORM, arguments: { //arguments permite enviar datos de tipo Map a otra página
                            'descripcion': producto.descripcion,
                            'categoria': producto.categoria,
                            'precio': producto.precio,
                            'disponibilidad': producto.disponibilidad,
                            'id': producto.idProducto,
                          });
                          actualizarEstado();
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: (){
                          deleteProducto(producto);
                          actualizarEstado();
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ]
                  ),
                ],
              ),
            ],
          ),
        ]
      ),
    );    

  }
}