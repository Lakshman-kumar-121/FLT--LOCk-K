import 'package:flutter/material.dart';
import 'package:lock/drawer/fileview.dart';
import 'package:lock/main.dart';

class Try extends StatefulWidget {
  const Try({Key? key}) : super(key: key);

  @override
  State<Try> createState() => TryState();
}
class TryState extends State<Try> {
  @override
  void initState() {
    super.initState();
    service.getAllDocName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          child: Container(
        child: FutureBuilder<dynamic>(
          future: service.getAllDocName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (service.num == 0) {
              return Center(
                child: Text(
                  "Folder List is empty!",
                  style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                ),
              );
            }
            return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 6 / 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8),
                padding: EdgeInsets.all(10),
                itemCount: service.num,
                itemBuilder: (context, index) {
                  return Container(
                      child: Column(
                    children: [
                      Material(
                        child: InkWell(
                          child: Container(
                              color: Colors.grey[300],
                              height: MediaQuery.of(context).size.height / 9.5,
                              width: MediaQuery.of(context).size.height / 3,
                              child: Icon(
                                Icons.folder,
                                size: 80,
                              )),
                          splashColor: Colors.black26,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => listFile(
                                        "${service.namelist[index]}")));
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.grey[700],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${getName(index)}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            PopupMenuButton(
                                onSelected: (valve) {
                                  if (valve == settings.delete) {
                                    Future.delayed(Duration(milliseconds: 0),
                                        showdeltealert(getName(index)));
                                  }
                                  ;
                                  if (valve == settings.rename) {
                                    Future.delayed(Duration(microseconds: 0),
                                        showRenamePop("${getName(index)}"));
                                  }
                                },
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                          child: Row(children: [
                                            Icon(Icons.delete),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("Delete",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ]),
                                          value: settings.delete),
                                      PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(Icons
                                                .drive_file_rename_outline),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("Rename",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                        value: settings.rename,
                                      )
                                    ])
                          ],
                        ),
                      ),
                    ],
                  ));
                });
          },
        ),
      )),
    );
  }

  getName(index) {
    return (service.namelist?[index]);
  }

  showRenamePop(oldId) {
    var newname = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Rename folder",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: TextField(
                controller: newname,
                autofocus: true,
              ),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        primary: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        primary: Color.fromARGB(255, 0, 102, 255),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onPressed: () async {
                      if (newname.text.isNotEmpty) {
                        Navigator.of(context).pop();
                        await service.renameDocument(oldId, newname.text.trim());

                        setState(() {});
                      }
                    },
                    child: Text(
                      "Change",
                      style: TextStyle(fontSize: 16),
                    )),
              ],
            ));
  }

  showdeltealert(getname) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: EdgeInsets.all(45),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Warning",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: Container(
                  width: double.infinity,
                  child: Text("Are you sure to delte this folder?")),
              actions: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[300],
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 12),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[800]),
                          )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 0, 102, 255),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            service.deleteFirestoredoc(getname);
                            service.deleteFolderStorage(getname);
                            setState(() {});
                          },
                          child: Text(
                            "Confirm",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ))
                    ],
                  ),
                )
              ],
            ));
  }
}

enum settings { delete, rename }
