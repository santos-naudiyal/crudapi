

import 'package:apicrud/services/todo_services.dart';
import 'package:apicrud/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo,});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  //TextEditingController timecontroller = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      isEdit = true;
      final todo = widget.todo;
      if(todo != null){
        isEdit = true;
        final title = todo['title'];
        final description = todo['description'];
        final time = todo['time'];
        titlecontroller.text = title;
        descriptioncontroller.text = description;
      //  timecontroller.text = time;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
          ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titlecontroller,
           keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptioncontroller,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines:8,
          ),
          SizedBox(height: 20),

         // TextField(
        //    controller: timecontroller,
        //    decoration: InputDecoration(hintText: 'Time'),
        //    keyboardType: TextInputType.datetime,
           
        //  ),

          SizedBox(height: 20),
          ElevatedButton(onPressed: isEdit ? updateData : submitData, child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
             isEdit ? 'Update'  : 'submit',
              ),
          ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {

    final todo = widget.todo;
    if(todo == null){
      print('You can not call updated without todo data');
      return;
    }
    final id = todo['_id'];
   
//submit updated data to the server
final isSuccess = await TodoService.updateTodo(id, body);

if(isSuccess){
  
  showSuccessMessage(context, message:'Updation Success');
}else {
  showErrorMessage(context, message: 'Updation Failed');
}
}

  Future <void> submitData() async {
 //submit data to the server
final isSuccess = await TodoService.addTodo(body);
//show success or fail message based on status
if(isSuccess){
  titlecontroller.text = '';
  descriptioncontroller.text = '';
 // timecontroller.text = '';
  showSuccessMessage(context, message:'Creation Success');
}else {
  showErrorMessage(context , message: 'Creation Failed');
}

  }

  Map get body{
    // Get the data from form
     final title = titlecontroller.text;
    final description = descriptioncontroller.text;
   // final time = timecontroller.text;
   return{
  
  "title": title,
  "description": description,
 // "time": time,
  "is_completed": false,

};

  }


}