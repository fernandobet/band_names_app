import 'package:bands/src/models/band_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket =>_socket;

  SocketService() {
    this.init();
  }


  void init() {
    //Todo esto es para podernos conectar al socket, todo lo sacamos de la documentacion
    this._socket = IO.io('http://192.168.0.11:3001', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    this._socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
      print('connect');
    });

    this._socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

   /* socket.on('nuevo-mensaje', (payload) {
      print(payload.containsKey('nombre') ? payload['nombre'] : 'NOT FOUND');
      print(payload.containsKey('mensaje') ? payload['mensaje'] : 'NOT FOUND');
      print(payload.containsKey('mensaje2') ? payload['mensaje'] : 'NOT FOUND');
    });*/
  }
}
