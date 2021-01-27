import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    // socketService.socket.emit(event);


    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status -> ${socketService.serverStatus}',style: TextStyle(fontSize: 30),)
          ],
        ),
     ),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.message),
       onPressed: (){
          socketService.emit('emitir-mensaje', {
            'nombre':'Flutter',
            'mensaje': 'hola desde Xioami redmi 5+'
          });

       },
     )
   );
  }
}