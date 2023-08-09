import 'package:flutter/material.dart';
import 'package:brainvault/colors.dart';
import 'package:brainvault/screens/document_screen.dart';
import 'package:brainvault/services/database_service.dart';

class CollectionScreen extends StatefulWidget {
  final int collectionId;

  CollectionScreen({super.key, required this.collectionId});

  @override
  // ignore: library_private_types_in_public_api
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final dbHelper = DatabaseService();
  late List<Map<String, dynamic>> documents;
  late Map<String, dynamic> collection;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool isLoading = true;
  bool hidden = true;
  bool _isHoverDelete = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      collection = await dbHelper.getCollectionById(widget.collectionId);
      documents =
          await dbHelper.getDocumentsByCollectionId(widget.collectionId);
      _titleController.text = collection['title'];
      _descriptionController.text = collection['description'];

      // When successfull
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Loading Data Failed: $e");
    }
  }

  void refreshData() async {
    setState(() {
      hidden = false;
    });
    try {
      var col = await dbHelper.getCollectionById(widget.collectionId);
      var doc = await dbHelper.getDocumentsByCollectionId(widget.collectionId);

      // When succesfull
      setState(
        () {
          collection = col;
          documents = doc;
        },
      );
    } catch (e) {
      print('Failed to refreshd data: $e');
    }
    setState(() {
      hidden = true;
    });
  }

  void updateTitle() async {
    await dbHelper.updateCollectionTitle(
        widget.collectionId, _titleController.text);
  }

  void updateDescription() async {
    await dbHelper.updateCollectionDescription(
        widget.collectionId, _descriptionController.text);
  }

  void _deleteCollection() async {
    await dbHelper.deleteCollection(widget.collectionId);
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.black),
          onPressed: () async {
            var data = {
              'collection_id': widget.collectionId,
              'title': 'Untitled',
              'position': documents.length + 1,
              'table_name': 'document',
            };
            try {
              int id = await dbHelper.insertDocument(data);

              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DocumentScreen(
                  documentId: id,
                  studyMode: false,
                ),
              ));
              refreshData();
            } catch (e) {
              print("Document creation failed: $e");
            }
          },
          backgroundColor: palette[5],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            color: palette[1],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: EditableText(
                              onChanged: (newText) {
                                updateTitle();
                              },
                              expands: true,
                              maxLines: null,
                              minLines: null,
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
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          await  showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: palette[2],
                                            title:
                                                Text('Delete this collection?'),
                                            content:
                                                Text('This action cannot be undone.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _deleteCollection();
                                                  Navigator.pop(
                                                      context); // Close the dialog
                                                  Navigator.pop(
                                                      context); // Close the document screen
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                        },
                        child: MouseRegion(
                          onHover: (event){
                            setState(() {
                              _isHoverDelete = true;
                            });
                          },
                          onExit: (event){
                            setState(() {
                              _isHoverDelete = false;
                            });
                          },
                          child: Icon(
                            Icons.delete_forever,
                            color: _isHoverDelete ? Colors.red : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Description and other buttons
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: EditableText(
                          onChanged: (newText) {
                            updateDescription();
                          },
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          backgroundCursorColor: palette[1],
                          cursorColor: Colors.white,
                          controller: _descriptionController,
                          focusNode: FocusNode(canRequestFocus: true),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (!hidden)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        children: [
                          for (var document in documents)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () async {
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (_) => DocumentScreen(
                                      documentId: document['id'],
                                      studyMode: false,
                                    ),
                                  ));
                                  refreshData();
                                },
                                child: Container(
                                  height: 100,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: palette[4],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      document['title'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
  }
}
