/*import 'package:cpy/constants/globals.dart';
import 'package:cpy/data/models/hymn_song.dart';
import 'package:cpy/supabase.dart';
import 'package:flutter/material.dart';

class TestData extends StatefulWidget {
  const TestData({super.key});

  @override
  State<TestData> createState() => _TestDataState();
}

class _TestDataState extends State<TestData> {

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<HymnSong> datas = [];

  void getData() async{
    var data = await databaseService.getAllSongs();

    print(data);
    setState(() {
      datas = data!;
    });

  }

  @override
  Widget build(BuildContext context) {

    SupabaseServices database = SupabaseServices();

    return Scaffold(
      appBar: AppBar(
        title: Text(datas.length.toString()),
      ),
      body: StreamBuilder(
          stream: database.stream,
          builder: (context, snapshot){
            if(snapshot.hasData){

              final appointments = snapshot.data;

              return Text(appointments!.length.toString());


            }else{
              return const Text('nothing yet');
            }
          }
      ),
    );
  }
} */
