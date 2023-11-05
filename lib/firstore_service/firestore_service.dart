import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lock/main.dart';

class firestore_service {
  var num, fieldnum, updatestatus;
  var _instance = FirebaseFirestore.instance;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('folder');

  void createFolder(String name) {
    final colref = _instance.collection(UserId).doc(name);
    colref.set(({}));
  }

  void deleteFirestoredoc(String name) {
    _instance.collection(UserId).doc(name).delete();
  }

  var namelist;
  getAllDocName() async {
    QuerySnapshot snap = await _instance.collection(UserId).get();
    List<String> documentName = snap.docs.map((e) => e.id).toList();
    namelist = documentName;
    num = documentName.length;
  }

  Future checkupdate() async {
    var _col_update = await _instance.collection('Admin_accesory').doc('update').get();
    if (_col_update.exists) {
      Map<String, dynamic>? data = await _col_update.data();
      updatestatus = data?["update"];
      return updatestatus;
    }
  }

  Map<String, dynamic>? data;
  Future getAllfield(String doc) async {
    var ref = await _instance.collection(UserId).doc(doc).get();
    if (ref.exists) {
      data = ref.data();
      fieldnum = data?.length;
    }
  }

  Future deleteFirestoredata(int index, String docName) async {
    var deltedata = await _instance.collection(UserId).doc(docName).get();

    final updates = {
      "${deltedata.data()?.keys.elementAt(index)}": FieldValue.delete(),
    };

    await _instance.collection(UserId).doc(docName).update(updates);
  }

  Future updateFiledoc(String document, String name, String url) async {
    var ref = _instance.collection(UserId).doc(document);
    var filedata = {name: url};
    ref.set(
        filedata,
        SetOptions(
          merge: true,
        ));
  }

  deleteFolderStorage(String folderName) async {
    String path = UserId + "/" + folderName + "/";
    print(path);
    FirebaseStorage.instance.ref().child(path).listAll().then((value) {
      value.items.forEach((element) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      });
    });
  }

  delteFile(String fileName, String folderName) {
    String path = UserId + "/" + folderName + "/" + fileName;
    FirebaseStorage.instance.ref().child(path).delete();
  }

  Future renameDocument(String oldId, String newName) async {
    var olddoc = await _instance.collection(UserId).doc(oldId).get();
    if (olddoc.exists) {
      _instance
          .collection(UserId)
          .doc(newName)
          .set(Map.from(olddoc.data() ?? {}));
      deleteFirestoredoc(oldId);
    }
  }

  String getFileName(String url) {
    RegExp regExp = new RegExp(r'.+(\/|%2F)(.+)\?.+');
    var matches = regExp.allMatches(url);
    var match = matches.elementAt(0);

    var temp = Uri.decodeFull(match.group(2)!).split(".").last;
    if (temp == "jpg" || temp == "jpeg" || temp == "png" || temp == "tga") {
      return "Image";
    }
    if (temp == "pdf") {
      return "Pdf";
    }
    if (temp == "mp3" || temp == "wav" || temp == 'mp4' ||
    temp == 'ogg' ||temp == 'aac' ||temp == 'awb'|| temp == 'amr' ||temp == 'waw'||temp == 'm4a'  || temp == 'opus'    ) {
      return "mp3";
    }
    return "";
  }

  void sendFeedback(info) {
    _instance.collection("Admin_accesory").doc("feedback").set(
          ({UserId: info}),SetOptions(merge : true)
        );
  }
}
