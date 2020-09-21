class BandModel{
  final String id;
  final String name;
  final int votes;

  BandModel({this.id, this.name, this.votes});

  factory BandModel.fromMap(Map<String,dynamic>mapa){
    return BandModel(
      id:     mapa.containsKey('id')    ? mapa['id']      :'no-id',
      name:   mapa.containsKey('name')? mapa['name']      :'no-name',
      votes:  mapa.containsKey('votes') ? mapa['votes']  :'no-votes'
    );
  }
}