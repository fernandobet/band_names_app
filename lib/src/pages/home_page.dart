import 'package:bands/src/models/band_model.dart';
import 'package:bands/src/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String route = 'Home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BandModel> _bandas = [];
  @override
  void initState() {
    super.initState();
    print('!!!!!!!!!!!!!!!!!!!INIT STATE!!!!!!!!!!!!!!!!!');
    final _socketService = Provider.of<SocketService>(context, listen: false);
    _socketService.socket.on('active-bands', (payload) {
      print('!!!!!!!!SOCKET SERVICE!!!!!!!');
      var bandas =
          (payload as List).map((banda) => BandModel.fromMap(banda)).toList();
      this._bandas = bandas;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print('!!!!!!!!!!!!!!!!!!!BUILD !!!!!!!!!!!!!!!!!');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Mis bandas de musica',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 10.0),
              child: Consumer<SocketService>(builder: (_, _provider, widget) {
                print('CONSUMER STATUS');
                print('${_provider.serverStatus.toString()}');
                return _provider.serverStatus == ServerStatus.Online
                    ? Icon(
                        Icons.offline_pin,
                        color: Colors.blue,
                      )
                    : Icon(Icons.offline_bolt, color: Colors.red);
              }))
        ],
      ),
      body: Column(
        children: <Widget>[
          _crearGrafica(),
          Expanded(
              child: ListView.builder(
                  itemCount: _bandas?.length ?? 0,
                  itemBuilder: (_, index) {
                    return buildCrearBanda(_bandas[index]);
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: buildAgregarBanda),
    );
  }

  _crearGrafica() {
    Map<String, double> dataMap = new Map();

    if(_bandas.length>0){
      _bandas.forEach((band) { 
        dataMap.putIfAbsent(band.name,() => band.votes.toDouble());
      });
    }

    return Container(
      width: double.infinity,
      height: 300,
      child: PieChart(dataMap: dataMap),
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
            ),
            actions: <Widget>[
              CupertinoButton(
                  child: Text('Agregar'),
                  onPressed: () => buildAddToList(_textController.text)),
              CupertinoButton(
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }

  buildAddToList(String nombreBanda) {
    if (nombreBanda != null && nombreBanda != "") {
      final _socketService = Provider.of<SocketService>(context, listen: false);
      _socketService.socket.emit('add-band', {'name': nombreBanda});
    }
    Navigator.pop(context);
  }

  Widget buildCrearBanda(BandModel banda) {
    final _socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        _socketService.socket.emit('remove-band', {'id': banda.id});
      },
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
          child: Text('${banda.name.substring(0, 2)}'),
        ),
        trailing: CircleAvatar(
            backgroundColor: Colors.white, child: Text('${banda.votes}')),
        title: Text('${banda.name}'),
        onTap: () {
          _socketService.socket.emit('vote-band', {'id': banda.id});
        },
      ),
    );
  }
}
