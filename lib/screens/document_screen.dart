import 'package:flutter/material.dart';

import '../colors.dart';


class DocumentScreen extends StatefulWidget{
  final int documentId;

  DocumentScreen({required this.documentId});

  @override 
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen>{
  final TextEditingController _titleController = TextEditingController();

  @override 
  void initState(){
    super.initState();
    _titleController.text = 'Title';
  }
  @override 
  Widget build(BuildContext context){
    
    return LayoutBuilder(builder: ((context, constraints) {
      if (constraints.maxWidth < 800){
        // Mobile View
        return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            color: palette[1],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: EditableText(
                        backgroundCursorColor: palette[1],
                        cursorColor: Colors.white,
                        controller: _titleController,
                        focusNode: FocusNode(canRequestFocus: true),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                 Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: palette[2],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Write something on the editor.'),
                  ),
                ),
              ),
              ],
            ),
          ),
        );
      }
        // Desktop View
        return Scaffold();
    }));
  }
}