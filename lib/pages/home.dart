import 'dart:io';
import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands=[
    // Band(id: '1',name: 'metalica', votes: 3),
    // Band(id: '2',name: 'naranja', votes: 5),
    // Band(id: '3',name: 'daddy', votes: 0),
    // Band(id: '4',name: 'Don!', votes: 1),
  ];
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context,listen: false);
    //se escucha al servidor
    socketService.socket.on('active-bands',(payload){
      print(payload);
      this.bands= (payload as List)
        .map( (band) => Band.fromMap(band) )
        .toList();

        setState(() {}); 
    });

    super.initState();
  }

  @override
  void dispose() { 
    final socketService = Provider.of<SocketService>(context,listen: false);
    //se hace la limpieza
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true ,
        title: Text('Band Names',style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: (socketService.serverStatus==ServerStatus.Online)
            ? Icon(Icons.check_circle, color: Colors.blue,)
            : Icon(Icons.offline_bolt, color: Colors.red,)
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _showGraph(),
          Expanded(
              child: ListView.builder(
              itemCount: bands.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => _bandTile(bands[index]),
              ),
          ),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,

      ),
   );
  }

  Widget _bandTile(Band band) {
    final socketservice = Provider.of<SocketService>(context, listen: false);


    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ )=> socketservice.emit('delete-band',{'id': band.id})  ,
        background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment:Alignment.centerLeft,
          child: Text('Delete Band ',style: TextStyle(color: Colors.white),),
        )
      ),
          child: ListTile(
            leading: CircleAvatar(
              child: Text( band.name.substring(0,2)),
              backgroundColor: Colors.blue[100],
            ),
            title: Text(band.name),
            trailing: Text('${band.votes}',style: TextStyle(fontSize: 20),),
            onTap: ()=>socketservice.socket.emit('vote-band',{'id':band.id}),
          ),
    );
  }

addNewBand(){
  final textController = new TextEditingController();
  if(Platform.isAndroid){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('New Band Name: '),
          content: TextField(
            controller: textController,
          ), 
          actions: [
            MaterialButton(
              child: Text('Add'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: ()=> addBandToList(textController.text)
              
            )
          ],
        );
      },
  
  );
  }else{
  showCupertinoDialog(
      context: context, 
      builder: ( _ ){
        return CupertinoAlertDialog(
          title: Text('New Band Name2'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('add'),
              onPressed: () => addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop(context)
            )
          ],
        );
      }
  );
  }
  
}

  void addBandToList(String name){
    if(name.length>1){
      final sockServ = Provider.of<SocketService>(context,listen:  false);
      sockServ.emit('add-band',{'name' : name});
    }
    Navigator.pop(context);
  }
  //mostrar grafica
  _showGraph() {
  //   Map<String, double> dataMap = {
  //   "Flutter": 5,
  //   "React": 3,
  //   "Xamarin": 2,
  //   "Ionic": 2,
  // }; 
  Map<String, double> dataMap = new Map();
  bands.forEach((band) {
    dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
   });

  return Container(
    width: double.infinity,
    height: 300,
    child: PieChart(
      dataMap: dataMap
    )
  ) ;

  }

}
