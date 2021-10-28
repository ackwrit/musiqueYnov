import 'package:flutter/material.dart';

class ajouter extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ajouterState();
  }

}

class ajouterState extends State<ajouter>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Musique Ynov"),
      ),
      body: bodyPage(),
    );
  }



  Widget bodyPage(){
    return Column(
      children: [
        TextField(),
        TextField(),
        TextField(),
        TextField(),
        ElevatedButton.icon(
            onPressed: (){
              //importer image
            }, 
            icon: Icon(Icons.cloud_upload_outlined), 
            label: Text('Importer une image')
        ),
      ],
    );
  }

}