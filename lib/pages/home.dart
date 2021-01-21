import 'dart:io';
import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands=[
    Band(id: '1',name: 'metalica', votes: 3),
    Band(id: '2',name: 'naranja', votes: 5),
    Band(id: '3',name: 'daddy', votes: 0),
    Band(id: '4',name: 'Don!', votes: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names',style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) => _bandTile(bands[index]),
        
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,

      ),
   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction){
        print('direction: $direction');
        print('direction: ${band.id}');

      },
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
            onTap: (){
              print(band.name);
            },
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
      //podemos agregar
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {
        
      });
    }
    Navigator.pop(context);
  }

}
