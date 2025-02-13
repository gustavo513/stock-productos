import 'package:flutter/material.dart';
import 'package:repaso10/models/producto.dart';
import 'package:repaso10/routes/routes.dart';
import 'package:repaso10/services/productosServices.dart';

class ProductoFormPage extends StatefulWidget{
  const ProductoFormPage( {super.key} );

  @override
  State<ProductoFormPage> createState() => _ProductoFormPageState();
}

class _ProductoFormPageState extends State<ProductoFormPage>{

  final _formKey = GlobalKey<FormState>();

  TextEditingController descripcionController = TextEditingController(text: '');
  TextEditingController categoriaController = TextEditingController(text: '');
  TextEditingController precioController = TextEditingController(text: '');

  int _globalState = 0; //0 como estado incial del Widget principal, 1 cuando se actualiza el estado del Widget principal

  bool _disponibilidad = false; //estado del SwitchListTile

  void actualizarEstado(){
    setState(() {
      _globalState = 1;
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
            ),
          )
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: _buildMenuBar(),
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: _buildLateralMenu(),
      body: _buildForm(context),
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
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.PRODUCTOS_FORM);
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
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.HOME);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Productos'),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.PRODUCTOS_LIST);
            }
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context){

    Producto producto = Producto(descripcion: null, categoria: null, precio: null, disponibilidad: null);
    int sw = 0; //0 para guardar nuevo documento, 1 para editar

    if(!(ModalRoute.of(context)!.settings.arguments == null)){
      final arguments = ModalRoute.of(context)!.settings.arguments as Map; //a través de arguments se reciben los datos y se guardan en un objeto tipo Producto
      
      producto.descripcion = arguments['descripcion'];
      producto.categoria = arguments['categoria'];
      producto.precio = arguments['precio'];
      producto.disponibilidad = arguments['disponibilidad'];
      producto.idProducto = arguments['id'];

      if(_globalState == 0){
        descripcionController.text = producto.descripcion!;
        categoriaController.text = producto.categoria!;
        precioController.text = producto.precio.toString();
        _disponibilidad = producto.disponibilidad!;
      }
      sw = 1;
    }

    return Form(
      key: _formKey,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.orange[100],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10),
                width: 350,
                child: TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(
                    label: Text('Descripcion'),
                    hintText: 'Ingrese descripcion del producto',
                    border: OutlineInputBorder(),
                  ),
                  validator:(value) {
                    if(value == null || value.isEmpty){
                      return 'Por favor, ingrese un valor valido.';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: 350,
                child: TextFormField(
                  controller: categoriaController,
                  decoration: const InputDecoration(
                    label: Text('Categoria'),
                    hintText: 'Ingrese la categoria del producto',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Por favor, ingrese un valor valido.';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: 350,
                child: TextFormField(
                  controller: precioController,
                  decoration: const InputDecoration(
                    label: Text('Precio'),
                    hintText: 'Ingrese el precio del producto',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Por favor, ingrese un valor valido.';
                    }
                    return null;
                  },
                ),
              ),
              SwitchListTile(
                title: const Text('Disponibilidad'),
                value: _disponibilidad,
                onChanged: (bool? value) {
                  _disponibilidad = value!;
                  actualizarEstado();
                },
              ),
              ElevatedButton(
                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Procesando datos'),
                    ));
                                          
                    producto.descripcion = descripcionController.text;
                    producto.categoria = categoriaController.text;
                    producto.precio = int.parse(precioController.text);
                    producto.disponibilidad = _disponibilidad;

                    if(sw == 0){
                      await addProducto(producto).then((_){
                        Navigator.of(context).pop(Routes.PRODUCTOS_LIST);
                      });
                    }
                    else{
                      await editProducto(producto).then((_){
                        Navigator.of(context).pop(Routes.PRODUCTOS_LIST);
                      });
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}