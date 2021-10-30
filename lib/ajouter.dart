import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:musiqueynov/function/firestoreHelper.dart';
import 'package:musiqueynov/main.dart';
import 'package:random_string/random_string.dart';
import 'package:timelines/timelines.dart';


class ajouter extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ajouterState();
  }

}

class ajouterState extends State<ajouter>{
  String imageFilePath="";
  String audioFilePath="";
  String albumfile="";
  String titrefile="";
  String typeMusiquefile="Rap";
  String auteurfile="";
  PageController controller = PageController(initialPage: 0);
  int numeroPage =0;
  int progressIndicator = 0;
  late Uint8List? bytesImage;
  late Uint8List? bytesAudio;
  late String imageFileName="";
  late String videoFileName="";
  bool waiting = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
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
        Container(
          height: MediaQuery.of(context).size.height/1.5,

          padding: EdgeInsets.only(left: 20,right: 20),
          child: PageView(
            onPageChanged: (int number){
              setState(() {
                numeroPage = number;
                progressIndicator = number;
              });
            },

            controller: controller,
            children: [
              Center(
                child: albumSelector(),
              ),
              Center(
                child: auteurSelector(),
              ),
              Center(
                child: titreSelector(),
              ),
              Center(
                child: typeSelector(),
              ),
              Center(
                child: imageSelector(),
              ),
              Center(
                child: (waiting)?CircularProgressIndicator():audioSelector(),
              ),







            ],
          ),
        ),





        Container(
          padding: EdgeInsets.only(left: 10,right: 10),
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Timeline(
            scrollDirection: Axis.horizontal,

            children: [
              (progressIndicator>0)?DotIndicator(
                size: 20,
                color: Colors.green,

              ): OutlinedDotIndicator(
                size: 20,
                color: Colors.red,

              ),
              (progressIndicator>0)?SizedBox(
                height: 20.0,
                width: MediaQuery.of(context).size.width/6.5,
                child: SolidLineConnector(
                  color: Colors.green,

                ),
              ):SizedBox(
                height: 20.0,
                width: MediaQuery.of(context).size.width/6.5,
                child: DashedLineConnector(
                  color: Colors.red,
                  dash: 1,
                ),
              ),

              (progressIndicator>1)?DotIndicator(
                size: 20,
                color: Colors.green,

              ): OutlinedDotIndicator(
                size: 20,
                color: Colors.red,

              ),
              (progressIndicator>1)?SizedBox(
                height: 20.0,
                width: MediaQuery.of(context).size.width/6.5,
                child: SolidLineConnector(
                  color: Colors.green,

                ),
              ):SizedBox(
                height: 20.0,
                width: MediaQuery.of(context).size.width/6.5,
                child: DashedLineConnector(
                  color: Colors.red,
                  dash: 1,
                ),
              ),
              (progressIndicator>2)?DotIndicator(
                size: 20,
                color: Colors.green,

              ): OutlinedDotIndicator(
                size: 20,
                color: Colors.red,

              ),
              (progressIndicator>2)?SizedBox(
                height: 20.0,
                width: MediaQuery.of(context).size.width/6.5,
                child: SolidLineConnector(
                  color: Colors.green,

                ),
              ): SizedBox(
                height: 20.0,
                width: MediaQuery.of(context).size.width/6.5,
                child: DashedLineConnector(
                  color: Colors.red,
                  dash: 1,
                ),
              ),
              (progressIndicator>3)?DotIndicator(
                size: 20,
                color: Colors.green,

              ): OutlinedDotIndicator(
                size: 20,
                color: Colors.red,

              ),
              (progressIndicator>3)?SizedBox(
                height: 20.0,
                width: MediaQuery.of(context).size.width/6.5,
                child: SolidLineConnector(
                  color: Colors.green,

                ),
              ): SizedBox(
                height: 20.0,
                width: MediaQuery.of(context).size.width/6.5,
                child: DashedLineConnector(
                  color: Colors.red,
                  dash: 1,
                ),
              ),

              (progressIndicator>4)?DotIndicator(
                size: 20,
                color: Colors.green,

              ): OutlinedDotIndicator(
                size: 20,
                color: Colors.red,

              ),



            ],
          ),
        ),





        Container(
          padding: EdgeInsets.only(left:10,right: 10),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (numeroPage==0)?Container():ElevatedButton(
                child: Text("Pécedent"),
                onPressed: (){
                  controller.previousPage(duration: Duration(seconds: 1),curve: Curves.easeInOutSine);
                },
              ),
              (numeroPage==5)?Container(

                padding: EdgeInsets.only(left: 20,right: 20),
                child: ElevatedButton(

                    onPressed: () async{
                      setState(() {
                        waiting = true;
                      });
                      if(videoFileName!='' && imageFileName!=''){
                        await firestoreHelper().stockageAudio(videoFileName, bytesAudio!).then((value) {
                          setState(() {
                            audioFilePath = value;

                          });

                        });
                        await firestoreHelper().stockageImage(imageFileName, bytesImage!).then((value) {
                          setState(() {
                            imageFilePath = value;

                          });

                        });


                      }

                      if(audioFilePath!=''&& imageFilePath!=''){
                        Map<String,dynamic> map = {
                          "album":albumfile,
                          "auteur":auteurfile,
                          "durée":7,
                          "path_song":audioFilePath,
                          "photo":imageFilePath,
                          "titre":titrefile,
                          "type_musique":typeMusiquefile,
                        };


                        String uid = randomAlphaNumeric(20);
                        firestoreHelper().addMusique(uid, map);
                        setState(() {
                          waiting = false;
                        });
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context){
                              return MyHomePage(title: "Musique Ynov");
                            }
                        ));

                      }




                    },
                    child: Text("Enregistrement")
                ),
              ):ElevatedButton(
                child: Text("Suivant"),
                onPressed: (){
                  setState(() {
                    controller.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOutSine);
                    print(albumfile);
                  });
                },
              ),
            ],
          ),
        ),












      ],
    );



  }




  Widget albumSelector(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Entrer le nom de l'album",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
        SizedBox(height: 10,),
        TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              label: Text("Album")
          ),
          onChanged: (value){
            setState(() {
              albumfile = value;
            });

          },
        )

      ],
    );






  }



  Widget auteurSelector(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Entrer le nom de l'auteur",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
        SizedBox(height: 10,),
        TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              label: Text("Auteur")
          ),
          onChanged: (value){
            setState(() {
              auteurfile = value;
            });

          },
        )

      ],
    );






  }



  Widget titreSelector(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Entrer le titre de la musique",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
        SizedBox(height: 10,),
        TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              label: Text("titre")
          ),
          onChanged: (value){
            setState(() {
              titrefile = value;
            });

          },
        )

      ],
    );






  }



  Widget typeSelector(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Entrer le type de musique",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
        SizedBox(height: 10,),
        DropdownButtonFormField(
          decoration:InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            )
          ),
          value: typeMusiquefile,
            onChanged: (String? newValue){
            setState(() {
              typeMusiquefile = newValue!;
            });
            },
            items:<String>['Rap',"Electro","R&B","Rock","Dance"].map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList()

        ),

      ],
    );






  }



  Widget imageSelector(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (imageFileName=="")?Container():Image.memory(bytesImage!,height: 400,width: 400,),
        SizedBox(height: 10,),
        ElevatedButton.icon(
            onPressed: () async {
              //importer image
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                withData: true,
                type: FileType.image,


              );
              if(result != null){
                setState(() {
                  imageFileName= result.files.first.name;
                  bytesImage =result.files.first.bytes;
                  print(imageFileName);
                });




              }



            },
            icon: Icon(Icons.cloud_upload_outlined),
            label: Text('Importer une image')
        ),

      ],
    );






  }



  Widget audioSelector(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (videoFileName=="")?Container():Text(videoFileName),
        SizedBox(height: 10,),
        ElevatedButton.icon(
            onPressed: () async {
              //importer image
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                  withData: true,
                  type: FileType.custom,
                  allowedExtensions: ["mp3","mp4","wav"]

              );
              if(result != null){
                setState(() {
                  videoFileName = result.files.first.name;
                  bytesAudio =result.files.first.bytes;
                });



              }



            },
            icon: Icon(Icons.cloud_upload_outlined),
            label: Text('Importer une audio')
        ),

      ],
    );






  }





}