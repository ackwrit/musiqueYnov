import 'package:flutter/material.dart';
import 'package:musiqueynov/model/Morceau.dart';

class Listen extends StatefulWidget{



  Morceau music;
  Listen({required Morceau this.music});




  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListenState();
  }

}


class ListenState extends State<Listen>{
  double position=0.0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueAccent,
        title: Text('Jean ragenarock'),
      ),
      body: BodyState(),
    );
  }

  Widget BodyState(){
    return Column(
      children: [
        SizedBox(height: 10,),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width/1.2,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(widget.music.image),
                fit: BoxFit.fill
              )
            ),
          ),
        ),
        Text(widget.music.title),
        Text(widget.music.author),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fast_rewind),
            Icon(Icons.play_arrow,size: 40,),
            Icon(Icons.fast_forward)
          ],
        ),
        Slider.adaptive(
            value: position,
            activeColor: Colors.green,
            inactiveColor: Colors.red,
            onChanged: (va){
              setState(() {
                position = va;
              });
              print(position);

            })
        
      ],
    );
  }

}