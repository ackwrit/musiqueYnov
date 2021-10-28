import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
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

  //Variable

  statut lecture=statut.stopped;
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration position= Duration(seconds: 0);
  late StreamSubscription positionStream;
  late StreamSubscription stateStream;












  Duration duree = Duration(seconds: 0);
  late PlayerState pointeur;




  //////////



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configurationPlayer();
  }




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
            IconButton(
                icon:Icon(Icons.fast_rewind),
              onPressed: (){
                  lecture =statut.playing;
                  rewind();
              },

            ),
            (lecture==statut.stopped)?IconButton(
              icon:Icon(Icons.play_arrow,size: 40),
              onPressed: (){
                setState(() {
                  lecture = statut.paused;
                  play();
                });

              },
            ):
            IconButton(
                icon:Icon(Icons.pause,size: 40,),
              onPressed: (){
                  //musique en pause
                setState(() {
                  lecture = statut.stopped;
                  pause();
                });
              },
            ),
            IconButton(
              icon:Icon(Icons.fast_forward),
              onPressed: (){
                //musique en en avance
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(duree.inMinutes.toString()),
            Text("0.0")

          ],
        ),
        Slider.adaptive(
            max: 100,
            min: 0,
            value: position.inSeconds.toDouble(),
            activeColor: Colors.green,
            inactiveColor: Colors.red,
            onChanged: (va){
              setState(() {
                Duration duree = Duration(seconds: va.toInt());
                position = duree;
              });
              print(position);

            })
        
      ],
    );
  }



  Future play() async {
    if(position>Duration(seconds: 0)){
      await audioPlayer.play(widget.music.path_song,position: position);
    }
    else{
      await audioPlayer.play(widget.music.path_song,);
    }


    //configurationPlayer();

  }

  Future pause() async {
    await audioPlayer.pause();
    audioPlayer.seek(position);
    //configurationPlayer();

  }

  rewind(){
    if(position>= Duration(seconds: 5)){
      setState(() {
        audioPlayer.stop();
        audioPlayer.seek(Duration(seconds: 0));
        position = new Duration(seconds: 0);
        audioPlayer.play(widget.music.path_song);
      });
    }
  }



  configurationPlayer(){
    //audioPlayer = new AudioPlayer();
    positionStream = audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position =event;
      });
    });
    stateStream = audioPlayer.onPlayerStateChanged.listen((event) {
      if(event == statut.playing){
        setState(() async {

          duree = audioPlayer.getDuration() as Duration;
          print(duree);
        });



      } else if(event == statut.stopped){
        setState(() {
          lecture = statut.stopped;

        });
      }


    },onError: (message){
      print("erreur : $message");
      setState(() {
        lecture = statut.stopped;
        position = Duration(seconds: 0);
        duree = Duration(seconds: 0);
      });
    }
    );


  }

}






enum statut{
  playing,
  stopped,
  paused,
  rewind,
  forward
}