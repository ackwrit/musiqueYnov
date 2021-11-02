import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:musiqueynov/ajouter.dart';
import 'package:musiqueynov/function/firestoreHelper.dart';
import 'package:musiqueynov/listen.dart';
import 'package:musiqueynov/model/Morceau.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().actionStream.listen((event) {
    print(event);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List <Morceau>allMorceau;
  int _counter = 0;



  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationChannel notificationChannel = NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'titre de la notification',
      channelDescription: 'La description de la notification'

    );
    AwesomeNotifications().initialize(null, [notificationChannel]);


  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    AwesomeNotifications().isNotificationAllowed().then((permission){
      if(!permission){
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    return
      Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (){
                //ajouter un nouveau son
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return ajouter();
                    }
                ));
              },
              icon: Icon(Icons.add)
          ),
        ],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),

      body:Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue,Colors.green,Colors.purple,Colors.black,Colors.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          )
        ),
        child: StreamBuilder <QuerySnapshot>(
          stream: firestoreHelper().firescloud_music.snapshots(),
          builder: (context,snasphots){
            if(!snasphots.hasData){
              return Text('Aucune information');
            }
            else
            {
              List documents = snasphots.data!.docs;
              allMorceau = [];
              return GridView.builder
                (
                padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 2),
                  itemCount: documents.length,
                  itemBuilder: (context,index){
                    Morceau morceau = Morceau(documents[index]);

                      allMorceau.add(morceau);



                    return InkWell(
                      child:Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),

                              image: DecorationImage(
                                  image: NetworkImage(morceau.image),
                                  fit: BoxFit.fill
                              )
                          ),
                          height: 40,
                          child: Center(
                            child: Text(morceau.author,style: TextStyle(color: Colors.red),) ,

                          )


                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return Listen(allMorceaux:allMorceau,index: index,);
                        }));
                      },

                    );



                  }
              );
            }
          },

        )
        ,
      )



     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


