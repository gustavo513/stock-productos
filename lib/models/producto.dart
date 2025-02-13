class Producto{
  Producto({
    required this.descripcion,
    required this.categoria,
    required this.precio,
    required this.disponibilidad,
    this.idProducto
  });
  String? descripcion;
  String? categoria;
  int? precio;
  bool? disponibilidad;
  String? idProducto;
}