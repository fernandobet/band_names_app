import 'package:bands/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  static const route = 'Status';
  @override
  Widget build(BuildContext context) {
    final _socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(_socketService.serverStatus.toString())],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _socketService.socket.emit('nuevo-mensaje-cliente', 'Mensaje de floatin action button!!');
          }),
    );
  }
}
