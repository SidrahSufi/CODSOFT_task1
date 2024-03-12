import 'dart:async';


import 'package:flutter/material.dart';
import 'package:todo_app/sql_data.dart';

import '../constant/color.dart';



class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Map<String, dynamic>> _allData=[];
  bool _isLoading = true;

  void _refreshData() async {
    final data = await sql_data.getAllData();
    setState(() {
      _allData = data.map((item) => {...item, 'isChecked': false}).toList();
      _isLoading = false;
      // _allData = data;
      // _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }


 Future<void> _addData() async{
   await sql_data.createData(_titleController.text, _descpControlller.text);
   _refreshData();
 }

 Future<void> _updateData(int id) async{
   await sql_data.updateData(id,_titleController.text, _descpControlller.text);
   _refreshData();
 }

 Future<void> _deleteData(int id) async{
   await sql_data.deleteData(id);

   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    backgroundColor: Colors.black,
     content: Text("TODO DELETED"),
   ),
   );
   _refreshData();
 }
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descpControlller = TextEditingController();

  void showBottomSheet(int? id) async {
    if(id != null) {
      final existingData = _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descpControlller.text= existingData['descp'];
    }
    showModalBottomSheet(
       backgroundColor:Colors.white70,
        elevation: 5,
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
          padding: EdgeInsets.only(top: 30 , left:15, right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom +50,),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border:
                  OutlineInputBorder(),
                  hintText: "Title" ,



                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descpControlller,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Description",
                ),
              ),

              SizedBox(height: 20,),
              Center(
                child: ElevatedButton(
                  onPressed: () async{
                    if(id== null){
                      await _addData();
                    }
                    if(id !=null) {
                      await _updateData(id);

                      _titleController.text = "";
                      _descpControlller.text = "";
                    }
                    Navigator.of(context).pop();

                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      id == null ? "Create ToDo" : "Update ToDo",
                      style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              )

            ],
          ) ,
        )


    );
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor:  lightpurple ,
        elevation: 0,
        title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text(
        'Welocme back!',
        style: TextStyle(
        color: Colors.white,
        fontSize: 25.0,

    ),
    ),
    Container(
    height: 40,
    width:40,
    child: Image.asset("assets/images/avatar.png"),
    )
    ],
    )
    ),
 body:
    Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
    image: DecorationImage(image: AssetImage("assets/images/todobck2.jpg"),fit:BoxFit.cover),

    ),
  child: _isLoading
           ? Center(
             child: CircularProgressIndicator(),
           )
           : ListView.builder(
         itemCount: _allData.length,
         itemBuilder: (context,index) => Card(
           margin: EdgeInsets.all(15),

           child: ListTile(

               leading: Checkbox(
                 value: _allData[index]['isChecked'],
                 onChanged: (bool? newValue) {
                   setState(() {
                     _allData[index]['isChecked'] = newValue;
                   });
                 },
               ),
             title:
                   // Checkbox(
                   //     value: isChecked,
                   //     onChanged: (bool? newValue)
                   //     {
                   //       setState(() {
                   //         isChecked = newValue!;
                   //       });
                   //     }
                   //
                   // ),
           Text(
                 _allData[index]['title'],
                 style: TextStyle(
                   fontSize: 20,
                 ),
               ),
             subtitle:
             Text(_allData[index]['descp']) ,

             trailing: Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 IconButton(onPressed: () {
                   showBottomSheet(_allData[index]['id']);

                 },
                     icon: Icon (Icons.edit,
                  color: Colors.black,
                 )
                 ),
                 IconButton(onPressed: () {
                   _deleteData(_allData[index]['id']);

                 },
                     icon: Icon (Icons.delete,
                       color: Colors.black,
                     )
                 )
               ],
             )
             ),
           ),
         )
    ),


 floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
       child: Icon(Icons.add),
    ),

    );
  }
}
