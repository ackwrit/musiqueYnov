import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musiqueynov/ajouter.dart';
import 'package:musiqueynov/model/Morceau.dart';

import 'main.dart';

class Listen extends StatefulWidget{




  int index;
  List <Morceau> allMorceaux =[];
  Listen({required int this.index,required List <Morceau>this.allMorceaux});





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
  double volumeSound = 0.5;












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
        actions: [
          IconButton(
            icon:Icon(Icons.list),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return MyHomePage(title: 'Musique Ynov',);
                  }
              ));
            },
          ),
          IconButton(
              onPressed: (){
                //Ajouter un nouveau type musique
                audioPlayer.stop();
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return ajouter();
                  }
                ));
              },
              icon: Icon(Icons.add)
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            audioPlayer.stop();
            Navigator.pop(context);
          },
        ),
        shadowColor: Colors.blueAccent,
        title: Text('Musique Ynov'),
      ),
      body: BodyState(),
    );
  }

  Widget BodyState(){
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Center(
            child: AnimatedContainer(
              width: (lecture == statut.paused)?MediaQuery.of(context).size.width/1.2:MediaQuery.of(context).size.width/2,
              height: (lecture == statut.paused)?350:150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(widget.allMorceaux[widget.index].image),
                      fit: BoxFit.fill
                  )
              ),
              duration: Duration(seconds :1),
              curve: Curves.easeIn,
            ),
          ),
          SizedBox(height: 10,),
          Text(widget.allMorceaux[widget.index].title),
          Text(widget.allMorceaux[widget.index].author),
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
                  lecture = statut.playing;
                  forward();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(position.toString().substring(2,7)),
              Text(duree.toString().substring(2,7))

            ],
          ),


          Slider(
              max: (duree == null)?0.0:duree.inSeconds.toDouble(),
              min: 0.0,

              value: position.inSeconds.toDouble(),
              activeColor: Colors.green,
              inactiveColor: Colors.red,
              onChanged: (va){
                setState(() {
                  //audioPlayer.pause();
                  Duration time = Duration(seconds: va.toInt());
                  position = time;
                  audioPlayer.play(widget.allMorceaux[widget.index].path_song,position: position,volume: volumeSound);
                });
                print(position);

              }),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: (){
                    if(volumeSound-0.1 <=0){
                      setState(() {
                        volumeSound = 0;
                        audioPlayer.setVolume(volumeSound);

                      });

                    }
                    else
                    {
                      setState(() {
                        volumeSound = volumeSound - 0.1;
                        audioPlayer.setVolume(volumeSound);

                      });
                    }
                    //play();
                  },
                  icon: Icon(Icons.volume_down_rounded)
              ),
              Expanded(
                child: Slider(
                    max: 1.0,
                    min: 0.0,
                    value: volumeSound,
                    activeColor: Colors.amber,
                    inactiveColor: Colors.white,
                    onChanged: (value){
                      setState(() {
                        volumeSound = value;
                        audioPlayer.setVolume(volumeSound);
                      });
                    }
                ),
              ),

              IconButton(
                  onPressed: (){
                    if(volumeSound+0.1 >= 1){
                      setState(() {
                        volumeSound = 1;
                        audioPlayer.setVolume(volumeSound);
                      });

                    }
                    else
                    {
                      setState(() {
                        volumeSound = volumeSound + 0.1;
                        audioPlayer.setVolume(volumeSound);
                      });
                    }
                    //play();
                  },
                  icon: Icon(Icons.volume_up_rounded)
              ),
            ],
          ),



        ],
      ),
    );

  }



  Future play() async {
    if(position>Duration(seconds: 0)){
      await audioPlayer.play(widget.allMorceaux[widget.index].path_song,position: position,volume: volumeSound);
    }
    else{
      await audioPlayer.play(widget.allMorceaux[widget.index].path_song,position: position,volume: volumeSound);
    }


    //configurationPlayer();

  }

  Future pause() async {
    await audioPlayer.pause();
    //audioPlayer.seek(position);
    //configurationPlayer();

  }

  rewind(){
    if(position>= Duration(seconds: 5)){
      setState(() {
        audioPlayer.pause();
        audioPlayer.seek(Duration(seconds: 0));
        position = new Duration(seconds: 0);
        audioPlayer.play(widget.allMorceaux[widget.index].path_song,position: position);
      });
    }
    else
      {
        audioPlayer.stop();
        if(widget.index==0)
          {
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return Listen(
                      index: widget.allMorceaux.length-1, allMorceaux: widget.allMorceaux);
                }
            ));

          }
        else {
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return Listen(
                    index: widget.index - 1, allMorceaux: widget.allMorceaux);
              }
          ));
        }
      }
  }


  forward(){
 if(position.inSeconds+10<duree.inSeconds){
   setState(() {
     position = new Duration(seconds: position.inSeconds+10);
     audioPlayer.pause();
     audioPlayer.play(widget.allMorceaux[widget.index].path_song,position: position);
   });

 }
 else
   {
     if(widget.index==widget.allMorceaux.length-1)
       {
         audioPlayer.stop();
         Navigator.push(context, MaterialPageRoute(
             builder: (BuildContext context) {
               return Listen(index: 0, allMorceaux: widget.allMorceaux);
             }
         ));
       }
     else
       {
         audioPlayer.stop();
         Navigator.push(context, MaterialPageRoute(
             builder: (BuildContext context) {
               return Listen(index: widget.index+1, allMorceaux: widget.allMorceaux);
             }
         ));
       }


   }


  }



  configurationPlayer(){
    //audioPlayer = new AudioPlayer();
    //duree = audioPlayer.getDuration() as Duration;
    //print(duree);
    audioPlayer.setUrl(widget.allMorceaux[widget.index].path_song);

    positionStream = audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position =event;
      });
    });


    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duree = event;
      });
    });

    stateStream = audioPlayer.onPlayerStateChanged.listen((event) {
      if(event == statut.playing){
        setState(() async {

          duree = audioPlayer.getDuration() as Duration;
          //print(duree);
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