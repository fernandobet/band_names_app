class BandModel{
  final String id;
  final String nombre;
  final String votes;

  BandModel({this.id, this.nombre, this.votes});

  factory BandModel.fromMap(Map<String,dynamic>mapa){
    return BandModel(
      id: mapa['id'],
      nombre:mapa['nombre'],
      votes:mapa['votes']
    );
  }
}