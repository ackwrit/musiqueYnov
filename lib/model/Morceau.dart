

import 'package:cloud_firestore/cloud_firestore.dart';

class Morceau{
  //Attributs
  late String title;
  late String author;
  late String title_album;
  late String type_music;
  late String image;
  late double duree;
  late String path_song;


  Morceau(DocumentSnapshot snapshot){
    String identifiant = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String, dynamic>;
    title = map ["titre"];
    author = map ["auteur"];
    title_album = map ["album"];
    type_music = map ["type_musique"];
    image = map ["photo"] ;
    //duree = map ["durée"];
    path_song = map ["path_song"];

  }





  // Constructeur




  //méthode


}