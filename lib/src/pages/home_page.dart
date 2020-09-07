
import 'package:bands/src/models/band_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  static final String route = 'Home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<BandModel> bandas = [
    BandModel(id: '1', nombre: 'The doors', votes: '50'),
    BandModel(id: '2', nombre: 'AC/DC', votes: '20'),
    BandModel(id: '3', nombre: 'U2', votes: '39')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis bandas de musica'),
      ),
      body: ListView.builder(
          itemCount: bandas.length,
          itemBuilder: (_, index) => buildCrearBanda(bandas[index])),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), 
          onPressed: buildAgregarBanda
          ),
    );
  }

  buildAgregarBanda() {
    final _textController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Agregar registro'),
            content: TextField(
              controller: _textController,
            ) ,
            actions: <Widget>[
              CupertinoButton(child:Text('Agregar'),onPressed:()=> buildAddToList(_textController.text) ),
              CupertinoButton(child: Text('Cancelar'), onPressed:()=>Navigator.pop(context) )
            ],
          );
        });
  }

  buildAddToList(String nombreBanda){
    if(nombreBanda!=null && nombreBanda!="" ){
      int _id =int.parse(bandas.last.id);
      _id++;
      final modelo = new BandModel(id:_id.toString(),nombre: nombreBanda,votes: "10" );
      bandas.add(modelo);
      setState(() {});
    }
    Navigator.pop(context);
  }


  Widget buildCrearBanda(BandModel banda) {
    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.endToStart,
      background: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 260),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.restore_from_trash,
                color: Colors.white,
              ),
              Text(
                'Eliminar',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        color: Colors.red,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${banda.nombre.substring(0, 2)}'),
        ),
        title: Text('${banda.nombre}'),
        onTap: () {},
      ),
    );
  }

}
