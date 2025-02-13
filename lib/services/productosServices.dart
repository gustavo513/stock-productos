import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repaso10/models/producto.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

//listar productos
Future<List<Producto>> getProductos() async{
  List<Producto> productos = [];

  CollectionReference coleccion = db.collection('productos');

  QuerySnapshot queryProductos = await coleccion.get();

  queryProductos.docs.forEach((d){

    Map<String, dynamic> document = d.data() as Map<String, dynamic>;

    Producto p = Producto(
      descripcion: document['descripcion'], 
      categoria: document['categoria'], 
      precio: document['precio'], 
      disponibilidad: document['disponibilidad'],
      idProducto: d.id
    );
    productos.add(p);
  });

  return productos;
}

//agregar un producto
Future<void> addProducto(Producto producto) async{
  
  Map<String, dynamic> doc = {
    'descripcion': producto.descripcion,
    'categoria': producto.categoria,
    'precio': producto.precio,
    'disponibilidad': producto.disponibilidad,
  };

  await db.collection('productos').add(doc);
}

//editar un producto
Future<void> editProducto(Producto producto) async{

  Map<String, dynamic> doc = {
    'descripcion': producto.descripcion,
    'categoria': producto.categoria,
    'precio': producto.precio,
    'disponibilidad': producto.disponibilidad,
    'id': producto.idProducto,
  };

  await db.collection('productos').doc(doc['id']).set(doc);
}

//eliminar un producto
Future<void> deleteProducto(Producto producto) async{
  await db.collection('productos').doc(producto.idProducto).delete();
}