import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class firestoreHelper{
  
  
   final authBase = FirebaseAuth.instance;
   final firescloud = FirebaseFirestore.instance;
   final fireStorage = FirebaseStorage.instance;
   
   
   //
  final firescloud_music = FirebaseFirestore.instance.collection("morceaux");



  Future <String> stockageImage(String image, Uint8List data) async {
     TaskSnapshot download= await fireStorage.ref("cover/$image").putData(data);
     String urlChemin = await download.ref.getDownloadURL();
     return urlChemin;



  }


   Future <String> stockageAudio(String image, Uint8List data) async {
     TaskSnapshot download= await fireStorage.ref("musique/$image").putData(data);
     String urlChemin = await download.ref.getDownloadURL();
     return urlChemin;
  }

  addMusique(String uid,Map<String,dynamic>map){
    firescloud_music.doc(uid).set(map);
  }
}