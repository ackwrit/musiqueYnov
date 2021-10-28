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
}